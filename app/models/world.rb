class World
  include MongoMapper::Document

  def self.default_options
    {
      spawn_monsters:   true,
      spawn_animals:    true,
      allow_flight:     false,
      spawn_protection: true
    }
  end


  key :name,          String, unique: true
  key :slug,          String, unique: true
  key :options,       Hash,   default: default_options
  key :location,      String, default: 'USA1s'
  key :admin_ids,     Array
  key :player_ids,    Array
  key :chat_messages, Array
  timestamps!

  many :admins,  class: User, in: :admin_ids
  many :players, class: User, in: :player_ids

  ensure_index :slug, unique: true

  def host
    'pluto.minefold.com'
  end

  def to_param
    slug
  end

private

  before_validation :generate_slug

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

end
