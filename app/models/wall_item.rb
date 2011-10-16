class WallItem
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :wall, polymorphic: true
  belongs_to :user
end
