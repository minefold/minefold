class Gift < ActiveRecord::Base
  belongs_to :coin_pack
  belongs_to :parent, class_name: 'User'

  belongs_to :child, class_name: 'User'

  attr_accessible :customer_id, :email, :name, :to, :card_token, :coin_pack_id

  uniquify :token, length: 12


  attr_accessor :card_token

  validates_presence_of :coin_pack_id
  validates_presence_of :email


  def fulfill
    create_charge &&
    gift_coins_to_parent

  rescue Stripe::StripeError
    false
  end

  def total
    coin_pack.cents
  end

  def coins
    coin_pack.coins
  end

  def create_charge
    charge = Stripe::Charge.create(
      amount: coin_pack.cents,
      currency: 'usd',
      card: card_token,
      description: "Gift of #{coin_pack.description}"
    )

    self.charge_id = charge.id
    charge
  end

  def gift_coins_to_parent
    parent && parent.increment_coins!(360)
    true
  end

end
