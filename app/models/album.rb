class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title

  has_many :photos
  belongs_to :creator, class_name: 'User'
end
