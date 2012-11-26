class Order
  extend ActiveModel::Naming

  def to_model
    self
  end

  def new_record?; true; end
  def destroyed?; false; end



  attr_reader :user
  attr_reader :charge_id

  def self.find_from_charge(id)
    ch = Stripe::Charge.retrieve(id)
    user = User.where(customer_id: ch.customer).first
    coin_pack_id = ch.description.match(/\d+$/)[0].to_i
    new(user, coin_pack_id)
  end


  def initialize(user, coin_pack_id, card_token=nil)
    @user = user
    @coin_pack_id = coin_pack_id
    @card_token = card_token
  end

  def user_id
    @user.id
  end

  def coin_pack
    @coin_pack ||= if @coin_pack_id.is_a?(CoinPack)
      @coin_pack_id
    else
      @coin_pack_id and CoinPack.where(id: @coin_pack_id).first
    end
  end

  def valid?
    coin_pack && user && user.valid? && (user.customer_id? || @card_token)
  end

  def fulfill
    create_or_update_customer &&
    create_charge &&
    coin_user

  rescue Stripe::StripeError
    false
  end

  def total
    coin_pack.cents
  end

  def coins
    coin_pack.coins
  end

# protected

  def create_or_update_customer
    # No customer in Stripe yet
    if not user.customer_id?
      user.create_customer(@card_token)
      user.save

    # Customer has specified a new card
    elsif @card_token
      user.customer.card = @card_token
      user.customer.save

    # Customer is charging their card on file
    else
      true
    end
  end

  def create_charge
    charge = Stripe::Charge.create(
      amount: coin_pack.cents,
      currency: 'usd',
      customer: user.customer_id,
      description: coin_pack.description
    )

    @charge_id = charge.id
    charge
  end

  def coin_user
    user.increment_coins!(coin_pack.coins)
  end

  def to_param
    charge_id
  end

end
