module Concerns::Subscription
  extend ActiveSupport::Concern

  included do
    belongs_to :subscription
  end

  def active_subscription?
    subscription && subscription.expires_at.future?
  end

  def ensure_stripe_customer!(stripe_token, last4)
    if customer_id?
      c = Stripe::Customer.retrieve(customer_id)
      c.card = stripe_token
      c.save
      c

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

  def has_maps?
    trial? || (active_subscription? && subscription.maps?)
  end

  def max_players(funpack)
    allocation = if active_subscription?
      funpack.plan_allocations.where(plan_id: subscription.plan.id).first
    else
      funpack.plan_allocations.order(:players).last
    end

    allocation ? allocation.players : 0
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

    discount = plan.discount_cents(tradein: tradein ? self.coins : 0)

    update = {
      plan: plan.stripe_id,
    }

    if discount > 0
      coupon_id = "INTRO#{discount}OFF"
      create_coupon(coupon_id, discount)
      update.merge!(coupon: coupon_id)
    end

    stripe_sub = customer.update_subscription(update)

    attributes = {
      plan: plan,
      expires_at: Time.at(stripe_sub.current_period_end),
      discount: discount,
      last4: last4,
    }

    if subscription
      self.subscription.update_attributes(attributes)
    else
      self.subscription = Subscription.new(attributes)
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

  def update_card!(stripe_token, last4)
    ensure_stripe_customer!(stripe_token, last4)
    self.subscription.update_attribute :last4, last4
  end

  def charge_succeeded!
    self.subscription.update_attribute :expires_at, 1.month.from_now + 3.days
  end

  def payment_failed!
  end
end
