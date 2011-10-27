class Card
  include Mongoid::Document

  embedded_in :user
  
  field :type
  field :country
  field :exp_month
  field :exp_year
  field :last4

  def self.new_from_stripe(card)
    new(
      type: card.type,
      country: card.country,
      exp_month: card.exp_month,
      exp_year: card.exp_year,
      last4: card.last4
    )
  end

end
