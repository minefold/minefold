class Subscription < ActiveRecord::Base
  has_one :user
  belongs_to :plan

  def maps?
    plan.stripe_id != 'micro'
  end
end
