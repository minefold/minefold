class PlayRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :from, class_name:'User'
  belongs_to :to, class_name:'User'

  belongs_to :world
end