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

  def create_coupon(id, amount_off)
    begin
      Stripe::Coupon.create(
        id: id,
        amount_off: amount_off,
        currency: 'usd',
        duration: 'forever',
      )
    rescue Stripe::InvalidRequestError
      # ignore coupon already exists
    end
  end

  def subscribe!(plan, stripe_token, last4, tradein = false)
    customer = ensure_stripe_customer!(stripe_token, last4)

    discount = plan.discount_cents(intro: true, tradein: tradein ? self.coins : 0)
    coupon_id = "INTRO#{discount}OFF"
    create_coupon(coupon_id, discount)

    stripe_sub = customer.update_subscription(
      plan: plan.stripe_id,
      card: stripe_token,
      coupon: coupon_id
    )

    if subscription
      self.subscription.update_attributes(plan: plan, expires_at: Time.at(stripe_sub.current_period_end), discount: discount)
    else
      self.subscription = Subscription.new(plan: plan, expires_at: Time.at(stripe_sub.current_period_end), discount: discount)
      self.save!
    end

    if tradein
      self.coins = 0
      save!
    end

    # trigger max-players update on each server
    created_servers.each do |server|
      server.save!
    end

    self.subscription
  end
end
