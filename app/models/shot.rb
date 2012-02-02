class Shot
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :file, ShotUploader

  belongs_to :creator, class_name: 'User'

  field :title
  field :sha
  field :original_filename

  index :sha

end
