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
    credit_pack_id = ch.description.match(/\d+$/)[0].to_i
    new(user, credit_pack_id)
  end


  def initialize(user, credit_pack_id, card_token=nil)
    @user = user
    @credit_pack_id = credit_pack_id
    @card_token = card_token
  end

  def user_id
    @user.id
  end

  def credit_pack
    @credit_pack ||= if @credit_pack_id.is_a?(CreditPack)
      @credit_pack_id
    else
      @credit_pack_id and CreditPack.where(id: @credit_pack_id).first
    end
  end

  def valid?
    credit_pack && user && user.valid? && (user.customer_id? || @card_token)
  end

  def fulfill
    create_or_update_customer &&
    create_charge &&
    credit_user

  rescue Stripe::StripeError
    false
  end

  def total
    credit_pack.cents
  end

  def credits
    credit_pack.credits
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
      amount: credit_pack.cents,
      currency: 'usd',
      customer: user.customer_id,
      description: credit_pack.description
    )

    @charge_id = charge.id
    charge
  end

  def credit_user
    user.increment_credits!(credit_pack.credits)
  end

  def to_param
    @charge_id
  end

end
