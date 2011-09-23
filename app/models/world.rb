class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,    type: String
  slug  :name,    scope: :owner, index: true

  field :invite_only,     type: Boolean, default: false
  field :public_activity, type: Boolean, default: true

  field :seed,           type: String, default: ''
  field :game_mode,      type: Integer, default: 0
  field :difficulty,     type: Integer, default: 1
  field :pvp,            type: Boolean, default: true
  field :spawn_monsters, type: Boolean, default: true
  field :spawn_animals,  type: Boolean, default: true

  field :last_mapped_at, type: DateTime

  belongs_to :creator, class_name: 'User'
  belongs_to :owner, class_name: 'User'

  has_and_belongs_to_many :whitelist, class_name: 'User', inverse_of: nil

  embeds_many :wall_items, as: :wall

  embeds_many :world_photos, class_name: 'WorldPhoto', cascade_callbacks: true
  accepts_nested_attributes_for :world_photos, destroy: true


# VALIDATIONS

  validates_presence_of :name
  validates_numericality_of :game_mode,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1

  validates_numericality_of :difficulty,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 3

# SETTINGS

  def creative?
    game_mode == 1
  end

  def survival?
    game_mode == 0
  end

  def difficulty_label
    %w{peaceful easy normal hard}[difficulty]
  end

# PLAYERS

  def public?
    not invite_only?
  end

  def whitelisted?(user)
    owner == user or whitelist.include?(user)
  end

  # accepts_nested_attributes_for :whitelist
  def fucking_whitelist_ids=(vals)
    self.whitelist = vals.map {|v| User.find(v) }
  end


  def connected_player_ids
    REDIS.smembers("#{redis_key}:connected_players")
  end

  def connected_players
    User.find connected_player_ids
  end

  def connected_players_count
    connected_player_ids.size
  end

# COMMUNICATION

  def send_cmd(str)
    REDIS.publish("#{redis_key}:stdin", str)
  end

  private(:send_cmd)

  def say(msg)
    send_cmd "say #{msg}"
  end

  def tell(user, msg)
    send_cmd "/tell #{user.username} #{msg}"
  end


# MEDIA

  def mapped?
    not last_mapped_at.nil?
  end

  # def photos
  #   wall_items.each_with_object([]) do |item, photos|
  #     (item.media || []).each_with_object(photos) do |media, photos|
  #       photos << media if media['type'] == 'photo'
  #     end
  #   end
  # end

  def broadcast(event_name, data, socket_id=nil)
    pusher_channel.trigger event_name, data, socket_id
  end

  def pusher_channel
    Pusher[pusher_key]
  end

  def pusher_key
    # TODO Change to collection.name
    "#{self.class.name.downcase}-#{id}"
  end

  def redis_key
    "#{collection.name}:#{id}"
  end

  def to_param
    slug.to_param
  end

protected

  def self.default
    where(name: 'Minefold').cache.first
  end

end
