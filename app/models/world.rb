class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,    type: String
  slug  :name,    scope: :creator, permanent: true, index: true

  field :invite_only,     type: Boolean, default: false
  field :public_activity, type: Boolean, default: true

  field :seed,           type: String, default: ''
  field :pvp,            type: Boolean, default: true
  field :spawn_monsters, type: Boolean, default: true
  field :spawn_animals,  type: Boolean, default: true

  field :last_mapped_at, type: DateTime

  belongs_to :creator, class_name: 'User'
  belongs_to :owner, class_name: 'User'

  has_and_belongs_to_many :whitelist, class_name: 'User', inverse_of: nil

  embeds_many :wall_items, as: :wall


# VALIDATIONS

  validates_presence_of :name


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

  def mapped?
    not last_mapped_at.nil?
  end

  def photos
    wall_items.each_with_object([]) do |item, photos|
      (item.media || []).each_with_object(photos) do |media, photos|
        photos << media if media['type'] == 'photo'
      end
    end
  end

  def broadcast(event_name, data, socket_id=nil)
    pusher_channel.trigger event_name, data, socket_id
  end

  def pusher_channel
    Pusher[pusher_key]
  end

  def pusher_key
    "#{self.class.name.downcase}-#{id}"
  end

  def redis_key
    "#{self.class.name.downcase}:#{id}"
  end


  # TODO: @chrislloyd has no idea how this works, but it stops a route needing
  #       both the creator and the world. The real fix could involve it
  #       looking like [creator.slug, slug].to_param.
  def to_param
    slug.to_param
  end

protected

  def self.default
    where(name: 'Minefold').cache.first
  end

end
