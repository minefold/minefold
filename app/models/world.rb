class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  GAME_MODES = [:survival, :creative]
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :name, type: String
  slug  :name, scope: :creator, index: true

  field :seed,             type: String, default: ''
  field :game_mode,        type: Integer, default: GAME_MODES.index(:survival)
  # TODO: Create migration
  field :difficulty_level, type: Integer, default: DIFFICULTIES.index(:easy)
  field :pvp,              type: Boolean, default: true
  field :spawn_monsters,   type: Boolean, default: true
  field :spawn_animals,    type: Boolean, default: true

  field :last_mapped_at, type: DateTime

  belongs_to :creator, inverse_of: :created_worlds, class_name: 'User'
  has_and_belongs_to_many :whitelisted_players,
                          inverse_of: :whitelisted_worlds,
                          class_name: 'User'

  embeds_many :play_requests
  has_many :invites

  embeds_many :wall_items, as: :wall


# VALIDATIONS

  validates_presence_of :name
  validates_numericality_of :game_mode,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: GAME_MODES.size

  validates_numericality_of :difficulty_level,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: DIFFICULTIES.size


# SETTINGS

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


# PLAYERS

  def can_play?(user)
    not players.include?(user)
  end

  def available_player(username)
    User
      .not_in(_id: players.map {|p| p.id})
      .where(safe_username: username.downcase)
  end

  def whitelisted?(user)
    players.include? user
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


# COMMUNICATION

  def broadcast(event_name, data, socket_id=nil)
    pusher_channel.trigger event_name, data, socket_id
  end

  def say(msg)
    send_cmd "say #{msg}"
  end

  def tell(user, msg)
    send_cmd "/tell #{user.username} #{msg}"
  end


# MAPS

  def mapped?
    not last_mapped_at.nil?
  end


# OTHER

  def pusher_channel
    Pusher[pusher_key]
  end

  def pusher_key
    "#{collection.name.downcase}-#{id}"
  end

  def redis_key
    "#{collection.name.downcase}:#{id}"
  end

  def to_param
    slug.to_param
  end

private

  def current_player_ids
    REDIS.smembers("#{redis_key}:connected_players")
  end

  def send_cmd(str)
    REDIS.publish("#{redis_key}:stdin", str)
  end

end
