class World
  include MongoMapper::Document

  key :name,       String,  unique: true
  key :admin_ids,  Array
  key :player_ids, Array
  timestamps!

  many :admins,  :class => User, :in => :admin_ids
  many :players, :class => User, :in => :player_ids


  key :slug, String, :unique => true
  ensure_index :slug, :unique => true

  def to_param
    slug
  end

private

  # TODO: Allow slugs to be changed when name changes
  before_create do
    base_slug = possible_slug = self.name.to_url
    n = 0

    while self.class.exist?(:slug => possible_slug)
      n += 1
      possible_slug = "#{base_slug}-#{n}"
    end

    self.slug = possible_slug
  end

end
