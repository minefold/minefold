module Concerns::Subscription
  extend ActiveSupport::Concern

  included do
    belongs_to :subscription
  end
  
  def active_subscription?
    subscription and subscription.expires_at > Time.now
  end
  
  def ensure_stripe_customer!(stripe_token, last4)
    if customer_id?
      Stripe::Customer.retrieve(customer_id)

    else
      customer = Stripe::Customer.create(
        email: email,
        card:  stripe_token
      )
      self.customer_id = customer.id
      self.save!

      customer
    end
  end

  def subscribe!(plan, stripe_token, last4)
    customer = ensure_stripe_customer!(stripe_token, last4)
    stripe_sub = customer.update_subscription(
      plan: plan.stripe_id,
      card: stripe_token
    )

    self.subscription = Subscription.new(plan: plan, expires_at: Time.at(stripe_sub.current_period_end))
    self.save!
    self.subscription
  end
end
