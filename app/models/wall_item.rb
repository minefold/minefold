class WallItem
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :wall_items, polymorphic: true
  belongs_to :creator, class_name: 'User'
end
