class World
  include MongoMapper::Document

  key :name, String, unique: true
  key :slug, String, unique: true, index: true
  key :private, Boolean, default: true

  key :player_ids, Array
  many :players, class: User, in: :player_ids

  many :wall_items, as: :wall,
                    sort: :created_at.desc

  # TODO: Needs migration
  key :seed, String, default: ''
  key :pvp, Boolean, default: true
  key :spawn_monsters, Boolean, default: true
  key :spawn_animals, Boolean, default: true

  validates_presence_of :name
  validates_presence_of :slug

  userstamps!
  timestamps!

  scope :public, private: false
  scope :private, private: true

  def public?
    not public?
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

  def to_param
    slug
  end

  def self.default
    find_by_name 'Minefold'
  end

  def photos
    wall_items.each_with_object([]) do |item, photos|
      item.media.select {|m| m['type'] == 'photo'}.each do |photo|
        photos << photo
      end
    end
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
