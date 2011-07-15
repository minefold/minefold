class WallItem
  include MongoMapper::Document

  belongs_to :wall, polymorphic: true
  timestamps!
end
