class Order
  include Mongoid::Document
  field :plan, default: 'free'
end
