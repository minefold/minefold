class Order < Struct.new(:credit_pack_id, :user, :card_token)

  attr_reader :charge_id

  def credit_pack
    @credit_pack ||= if credit_pack_id.is_a?(CreditPack)
      credit_pack_id
    else
      begin
        credit_pack_id and CreditPack.find(credit_pack_id)
      rescue ActiveRecord::RecordNotFound
      end
    end
  end

  def valid?
    credit_pack and user and user.valid? and (user.customer_id? or card_token)
  end

  def fulfill
    create_or_update_customer and
    create_charge and
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
      user.create_customer(card_token)
      user.save

    # Customer has specified a new card
    elsif card_token
      user.customer.card = card_token
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

end
