class World
  include MongoMapper::Document

  key :name,       String,  unique: true
  key :private,    Boolean, default: true
  key :admin_ids,  Array
  key :player_ids, Array
  timestamps!

  many :admins,  class_name: 'User', in: :admin_ids
  many :players, class_name: 'User', in: :player_ids

  ensure_index :slug

  # TODO: Proper slugs
  def to_param
    name
  end

end
