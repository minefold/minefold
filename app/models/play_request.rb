class PlayRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :world
  belongs_to :user
end
