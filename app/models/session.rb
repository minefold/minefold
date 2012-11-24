class Session < ActiveRecord::Base
  belongs_to :server

  attr_accessible :ended_at, :started_at

  default_scope order(:created_at).reverse_order
  scope :active, where(ended_at: nil)

end
