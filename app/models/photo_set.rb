class PhotoSet
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  embedded_in :world
  embeds_many :photos
  
  field :title
  
  accepts_nested_attributes_for :photos
end
  