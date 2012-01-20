class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :file, PhotoUploader

  belongs_to :creator, class_name: 'User'

  field :caption
end
