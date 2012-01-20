class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug


  field :name, type: String
  validates_uniqueness_of :name
  validates_presence_of :name

  slug  :name, index: true

  scope :by_name, ->(name) {
    where(name: name)
  }

  field :desc, type: String

  belongs_to :creator,
    inverse_of: :created_worlds,
    class_name: 'User'

  embeds_many :memberships
  embeds_many :membership_requests do
    def include_user?(user)
      where(user_id: user.id).exists?
    end
  end

  has_many :events, as: :target,
                    order: [:created_at, :desc]

  field :last_mapped_at, type: DateTime

  field :minutes_played, type: Integer, default: 0


  # Game settings

  GAME_MODES = [:survival, :creative]
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :seed, type: String, default: ''

  field :game_mode, type: Integer, default: GAME_MODES.index(:survival)
  validates_numericality_of :game_mode,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: GAME_MODES.size

  field :difficulty_level, type: Integer, default: DIFFICULTIES.index(:easy)
  validates_numericality_of :difficulty_level,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: DIFFICULTIES.size

  field :pvp, type: Boolean, default: true
  field :spawn_monsters, type: Boolean, default: true
  field :spawn_animals, type: Boolean, default: true


  field :pageviews, type: Integer, default: 0
  validates_numericality_of :pageviews,
    only_integer: true,
    greater_than_or_equal_to: 0


# Validations



  # after_create do
  #   memberships.create role: 'op', user: creator
  # end

# Settings

  GAME_MODES.each do |mode|
    define_method("#{mode}?") do
      GAME_MODES[game_mode] == mode
    end
  end

  def difficulty
    DIFFICULTIES[difficulty_level]
  end

  DIFFICULTIES.each do |difficulty|
    define_method("#{difficulty}?") do
      DIFFICULTIES[difficulty_level] == difficulty
    end
  end


# Players

  def creator=(creator)
    membership = memberships.find_or_initialize_by(user: creator)
    membership.op!

    write_attribute :creator_id, creator.id
  end


  def add_member(user)
    memberships.new user: user
  end

  def member?(user)
    memberships.where(user_id: user.id).exists?
  end

  def op?(user)
    memberships.ops.where(user_id: user.id).exists?
  end

  def ops
    memberships.ops.map(&:user)
  end

  def members
    memberships.map {|m| m.user}
  end

  def players
    User.find(current_player_ids)
  end

  def offline_players
    User.find(memberships.map {|m| m.user_id} - current_player_ids)
  end

# Communication

  def record_event!(type, attrs)
    event = type.new(attrs)
    self.events.push(event) if event.valid?
    event
  end

  def broadcast(event_name, data, socket_id=nil)
    pusher_channel.trigger event_name, data, socket_id
  end

  def say(msg)
    send_stdin "say #{msg}"
  end

  def tell(user, msg)
    send_stdin "/tell #{user.username} #{msg}"
  end


# Maps

  def mapped?
    not last_mapped_at.nil?
  end

  def map_assets_url
    File.join ENV['WORLD_MAPS_URL'], id.to_s
  end


# Uploads

  def upload_filename_prefix
    [creator.safe_username, creator.id, Time.now.strftime('%Y%m%d%H%M%S'), nil].join('-')
  end


# Other

  def to_param
    slug.to_param
  end

  def pusher_key
    "#{collection.name.downcase}-#{id}"
  end

  def redis_key
    "#{collection.name.downcase}:#{id}"
  end

  def current_player_ids
    REDIS.smembers("#{redis_key}:connected_players").map {|id| BSON::ObjectId(id)}
  end

private

  def pusher_channel
    Pusher[pusher_key]
  end

  def send_stdin(str)
    world_data = REDIS.hget "worlds:running", id
    if world_data
      instance_id = JSON.parse(world_data)['instance_id']
      REDIS.publish("workers:#{instance_id}:worlds:#{id}:stdin", str)
    end
  end

end
