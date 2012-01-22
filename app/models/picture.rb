class Picture
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :file, PictureUploader

  belongs_to :creator, class_name: 'User'

  field :caption
end
