class Membership
  include Mongoid::Document
  include Mongoid::Timestamps

  OP = 'op'

  embedded_in :world
  belongs_to :user

  field :role
end
