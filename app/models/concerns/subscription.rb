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

  def bolts
    active_subscription? ? subscription.plan.bolts : 1
  end

  def max_players(funpack)
    funpack.player_allocations[bolts - 1]
  end

  def subscribe!(plan, stripe_token, last4)
    customer = ensure_stripe_customer!(stripe_token, last4)
    stripe_sub = customer.update_subscription(
      plan: plan.stripe_id,
      card: stripe_token
    )

    if subscription
      self.subscription.update_attributes(plan: plan, expires_at: Time.at(stripe_sub.current_period_end))
    else
      self.subscription = Subscription.new(plan: plan, expires_at: Time.at(stripe_sub.current_period_end))
      self.save!
    end

    # trigger max-players update on each server
    created_servers.each do |server|
      server.save!
    end

    self.subscription
  end
end
