class Photo
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia

  mount_uploader :file, PhotoUploader

  belongs_to :creator, class_name: 'User'

  belongs_to :world
  attr_accessible :world

  field :title, type: String
  slug :title, index: true
  attr_accessible :title

  field :sha, type: String, index: true

  field :public, type: Boolean, default: false
  scope :unsorted, where(public: false)
  scope :public, where(public: true)
  attr_accessible :public


  field :pageviews, type: Integer, default: 0
  validates_numericality_of :pageviews,
    only_integer: true,
    greater_than_or_equal_to: 0

  field :width, type: Integer
  field :height, type: Integer

  field :thumb_width, type: Integer
  field :thumb_height, type: Integer

  def to_param
    id.to_param
  end
end
