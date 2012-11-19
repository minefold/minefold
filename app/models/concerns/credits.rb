module Concerns::Credits
  extend ActiveSupport::Concern

  included do
    validates_presence_of :credits
    validates_numericality_of :credits

    scope :low_credit, where(
      arel_table[:credits].lt(Bonuses::CreditFairy.credits))

    scope :needs_credit_fairy, low_credit.where(
      arel_table[:last_credit_fairy_visit_at].eq(nil).or(
        arel_table[:last_credit_fairy_visit_at].lt(Bonuses::CreditFairy.period.ago)))
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
    self.class.update_counters(self.id, credits: n) == 1
  end

  # Slower, but does update the model's internal state.
  def increment_credits(n)
    transaction do
      increment_credits!(n)
      reload
    end
  end

  def purchase(product)
  end

end
