class WallItem
  include MongoMapper::Document
  belongs_to :wall, polymorphic: true
  belongs_to :user
  timestamps!
end
