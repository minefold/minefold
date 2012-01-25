class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  GAME_MODES = [:survival, :creative]
  LEVEL_TYPES = %W(DEFAULT FLAT)
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :name, type: String
  slug  :name, index: true

  field :seed,             type: String, default: ''
  field :game_mode,        type: Integer, default: GAME_MODES.index(:survival)
  field :level_type,       type: String,  default: LEVEL_TYPES.first
  field :difficulty_level, type: Integer, default: DIFFICULTIES.index(:easy)
  field :pvp,              type: Boolean, default: true
  field :spawn_monsters,   type: Boolean, default: true
  field :spawn_animals,    type: Boolean, default: true

  field :last_mapped_at, type: DateTime
  field :minutes_played, type: Integer, default: 0

  field :map_data, type: Hash
  field :world_data_file, type: String  # this is the world backup file in S3, can be blank

  belongs_to :creator, inverse_of: :created_worlds, class_name: 'User'
  belongs_to :world_upload

  embeds_many :play_requests


  has_many :events, as: :target,
                    order: [:created_at, :desc]
                    
  embeds_many :photos, order: [:created_at, :desc]
  
  embeds_many :memberships


# Validations

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_numericality_of :game_mode,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: GAME_MODES.size

  validates_numericality_of :difficulty_level,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: DIFFICULTIES.size
  
    after_create do
    memberships.create role: 'op', user: creator
  end

  after_create do
    # if world is being created from an upload, use the uploaded world data file as our starting point
    if world_upload
      self.world_data_file = world_upload.world_data_file 
      save!
    end
  end

# Finders

  scope :by_name, ->(name) {
    where(name: name)
  }


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

  def can_play?(user)
    not players.include?(user)
  end

  def search_for_potential_player(username)
    User
      .where(safe_username: User.sanitize_username(username))
      .not_in(_id: players.map {|p| p.id})
      .first
  end
  
  def find_potential_player(id)
    # makes sure id is not a current player
    raise Mongoid::Errors::DocumentNotFound if player_ids.map(&:to_s).include? id
    User.find(id)
  end

  def whitelisted?(user)
    players.include? user
  end

  # Memberships TODO: Refactor
  
  def add_player user
    memberships << Membership.new(user: user, role: 'player')
  end
  
  def ops
    memberships.where(role: 'op').map(&:user)
  end
  
  def opped?(user)
    ops.include? user
  end

  def players
    memberships.map(&:user)
  end
  
  def player_ids
    memberships.map(&:user_id)
  end

  def current_players
    User.find current_player_ids
  end
  
  def offline_players
    User.find(player_ids - current_player_ids)
  end

  def current_players_count
    current_player_ids.size
  end
  
# Communication
  
  def record_event!(type, data)
    event = type.new(data)
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
