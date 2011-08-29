class CreditEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :delta, type: Integer

  embedded_in :user
end
