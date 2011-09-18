class WorldPhoto
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  mount_uploader :image, WorldPhotoUploader
  validates_presence_of :image
  
  embedded_in :world
end