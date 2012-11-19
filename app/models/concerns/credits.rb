module Concerns::Credits
  extend ActiveSupport::Concern

  included do
    validates_presence_of :credits
    validates_numericality_of :credits
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

  # Atomically increment credits. Doesn't update the model's internal state.
  def increment_credits!(n)
    if self.class.update_counters(self.id, credits: n) == 1
      track_credits(n)
      true
    end
  end

# private

  def track_credits(n)
    Mixpanel.async_person_add(self.distinct_id, credits: n)
  end

end
