class PartyCloud::User
  include Mongoid::Document
  store_in collection: 'users'

  field :plan_expires_at, type: DateTime
  field :credits, type: Integer
end
