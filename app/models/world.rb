class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,    type: String
  slug  :name,    scope: :creator, permanent: true, index: true

  field :visible, type: Boolean, default: false
  field :public,  type: Boolean, default: false
  scope :public, where(public: true)
  scope :visible, where(visible: true)

  field :seed,           type: String, default: ''
  field :pvp,            type: Boolean, default: true
  field :spawn_monsters, type: Boolean, default: true
  field :spawn_animals,  type: Boolean, default: true

  belongs_to :creator, class_name: 'User', inverse_of: :created_worlds
  field :creator_slug, type: String

  has_and_belongs_to_many :players, class_name: 'User'

  embeds_many :wall_items, as: :wall


# VALIDATIONS

  validates_presence_of :name
  validates_presence_of :creator_slug


# PLAYERS

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

  # def send_cmd(str)
  #   REDIS.publish("#{redis_key}.stdin", str)
  # end
  #
  # private(:send_cmd)
  #
  # def broadcast(msg)
  #   send_cmd "say #{msg}"
  # end
  #
  # def broadcast(user, msg)
  #   send_cmd "/tell #{user.username} #{msg}"
  # end


# MEDIA

  def photos
    wall.each_with_object([]) do |item, photos|
      item.media.each_with_object(photos) do |media, photos|
        photos << media if media['type'] == 'photo'
      end
    end
  end

  def pusher_key
    "#{self.class.name.downcase}-#{id}"
  end

  def redis_key
    "#{self.class.name.downcase}:#{id}"
  end


  # TODO: @chrislloyd has no idea how this works, but it stops a route needing
  #       both the creator and the world. The real fix could involve it
  #       looking like [creator.slug, slug].join('/').
  def to_param
    creator.slug
  end

protected

  def self.default
    where(name: 'Minefold').cache.first
  end

end
