class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :creator, class_name: 'User'

  has_many :shots, dependent: :nullify

  field :name, type: String
  # slug  :name, index: true

  field :description, type: String
end
