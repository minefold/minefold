class Card
  include Mongoid::Document

  embedded_in :user

  field :type
  field :country
  field :exp_month
  field :exp_year
  field :last4

  def self.attributes_from_stripe(stripe_card)
    {
      type: stripe_card.type,
      country: stripe_card.country,
      exp_month: stripe_card.exp_month,
      exp_year: stripe_card.exp_year,
      last4: stripe_card.last4
    }
  end
  
  def number
    "**** **** **** #{last4}"
  end

end
