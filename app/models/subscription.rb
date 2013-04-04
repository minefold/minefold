class Subscription < ActiveRecord::Base
  has_one :user
  belongs_to :plan
end
