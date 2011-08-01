class World
  include MongoMapper::Document

  def self.default_options
    {
      'spawn-monsters' => true,
      'pvp' => true
    }
  end


  key :name, String, unique: true
  key :slug, String, unique: true, index: true
  key :options, Hash, default: default_options
  key :location, String, default: 'USA1'
  key :status, String, default: ''
  many :admins, class: User
  many :players, class: User

  many :wall_items, as: :wall,
                    sort: :created_at.desc,
                    limit: 100

  validates_presence_of :name
  validates_presence_of :slug

  timestamps!


  def self.recently_active
    sort(:updated_at.desc)
  end

  def self.available_to_play
    where(status:'')
  end

  def host
    'pluto.minefold.com'
  end

  def channel
    Pusher[channel_name]
  end

  def channel_name
    [self.class.name.downcase, self.id.to_s].join(':')
  end

  def connected_players
    User.find REDIS.smembers(redis_key(:connected_players))
  end

  def connected_players_count
    REDIS.smembers(redis_key(:connected_players)).size
  end

  # TODO: Ugly as sin.
  def options=(hash)
    super(self.class.default_options.each_with_object({}) do |(key, val), opts|
      opts[key] = hash[key].present? || opts[key].present?
    end)
  end

  def to_param
    slug
  end

  def self.default
    find_by_name 'Public'
  end

private

  before_validation :generate_slug

  # TODO: This is shit
  def generate_slug
    return unless name_changed? and name.present?

    # Generate a first guess at the slug
    self.slug = guess = self.name.to_url
    n = 0

    # Loops whilst a slug with same name exists, adding an integer to the end
    # each time. "foo", "foo-1", "foo-2" etc.
    #
    # Searching the DB each time isn't particularly performant but this is an
    # edge case, when two different names produce the same slug.
    while self.class.exist?(:slug => slug)
      self.slug = "#{guess}-#{n += 1}"
    end
  end

  def redis_key(*members)
    [self.class.name.downcase, id, *members.map{|m| m.to_s}].join(':')
  end

end
