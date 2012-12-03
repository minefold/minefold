module Concerns::Coins
  extend ActiveSupport::Concern

  included do
    validates_presence_of :coins
    validates_numericality_of :coins
  end

  def create_customer(card_token)
    c = Stripe::Customer.create(
      card: card_token,
      email: self.email,
      description: self.id.to_s
    )

    self.customer_id = c.id
  end

  def customer
    if customer_id?
      Stripe::Customer.retrieve(customer_id)
    end
  end

  # Atomically increment coins. Doesn't update the model's internal state.
  def increment_coins!(n)
    if self.class.update_counters(self.id, coins: n) == 1
      track_coins(n)
      true
    end
  end

  def spend_coins!(n)
    increment_coins!(-n)
    track_spend(n)
  end

# private

  def track_coins(n)
    Mixpanel.async_person_add(self.distinct_id, coins: n)
  end

  def track_spend(n)
    Librato.increment 'user.coins.spent', sporadic: true
  end

end