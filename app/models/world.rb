class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  GAME_MODES = [:survival, :creative]
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :name, type: String
  slug  :name, index: true

  field :seed,             type: String, default: ''
  field :game_mode,        type: Integer, default: GAME_MODES.index(:survival)

  field :difficulty_level, type: Integer, default: DIFFICULTIES.index(:easy)
  field :pvp,              type: Boolean, default: true
  field :spawn_monsters,   type: Boolean, default: true
  field :spawn_animals,    type: Boolean, default: true

  field :last_mapped_at, type: DateTime

  belongs_to :creator, inverse_of: :created_worlds, class_name: 'User'
  has_and_belongs_to_many :whitelisted_players,
                          inverse_of: :whitelisted_worlds,
                          class_name: 'User'

  has_and_belongs_to_many :ops,
                          inverse_of: :opped_worlds,
                          class_name: 'User'


  embeds_many :play_requests


  has_many :events, as: :target,
                    order: [:created_at, :desc]


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

  def whitelisted?(user)
    players.include? user
  end

  # TODO: Refactor
  def opped?(user)
    ([creator] + ops).include? user
  end

  def players
    [creator] + whitelisted_players
  end

  def current_players
    User.find current_player_ids
  end

  def current_players_count
    current_player_ids.size
  end


# Communication
  
  def record_event!(type, data)
    event = type.new(data)
    self.events.push(event)
    
    event_name = [event.pusher_key, 'created'].join('-')
    
    broadcast event_name, event.attributes
  end
  
  def broadcast(event_name, data, socket_id=nil)
    pusher_channel.trigger event_name, data, socket_id
  end

  def say(msg)
    send_cmd "say #{msg}"
  end

  def tell(user, msg)
    send_cmd "/tell #{user.username} #{msg}"
  end


# Maps

  def mapped?
    not last_mapped_at.nil?
  end
  
  def map_assets_url
    File.join('//s3.amazonaws.com', ENV['MAPS_BUCKET'], id.to_s)
  end


# Uploads

  def upload_filename_prefix
    [creator.safe_username, creator.id, Time.now.strftime('%Y%m%d%H%M%S'), nil].join('-')
  end

# Other
  
  def pusher_key
    "#{collection.name.downcase}-#{id}"
  end
  
  def broadcast(event_name, data, socket_id=nil)
    pusher_channel.trigger(event_name, data.to_json, socket_id)
  end

  def redis_key
    "#{collection.name.downcase}:#{id}"
  end

  def to_param
    slug.to_param
  end

  def pusher_channel
    Pusher[pusher_key]
  end

  def current_player_ids
    REDIS.smembers("#{redis_key}:connected_players")
  end

private

  def send_cmd(str)
    world_data = REDIS.hget "worlds:running", id
    if world_data
      instance_id = JSON.parse(world_data)['instance_id']
      REDIS.publish("workers:#{instance_id}:worlds:#{id}:stdin", str)
    end
  end

end
