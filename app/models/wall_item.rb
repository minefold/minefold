class WallItem
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :wall_items, polymorphic: true
  belongs_to :user
end
