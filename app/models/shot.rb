class Shot
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia

  mount_uploader :file, ShotUploader

  belongs_to :creator, class_name: 'User'

  belongs_to :shot_album

  field :title, type: String
  field :sha, type: String, index: true
  field :original_filename, type: String
  field :public, type: Boolean

  slug :title, index: true

end
