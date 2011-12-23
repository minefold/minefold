class Photo
  include Mongoid::Document
  embedded_in :photo_set
  
  mount_uploader :file, PhotoUploader
end
  