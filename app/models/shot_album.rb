class ShotAlbum
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  belongs_to :creator, class_name: 'User'

  has_many :shots, dependent: :nullify

  field :name, type: String, index: true
end
