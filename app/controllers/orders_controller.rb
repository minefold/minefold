class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    # Setup the stripe customer
    if current_user.customer_id?
      @customer = Stripe::Customer.retrieve(current_user.customer_id)
    else
      @customer = Stripe::Customer.create(
        email: current_user.email,
        card:  params[:stripeToken]
      )
      current_user.update_attribute :customer_id, @customer.id
    end

    # Update the customer's card on file
    @customer.card = params[:stripeToken]
    @customer.save

    @coin_pack = CoinPack.find(params[:coin_pack_id])

    @charge = Stripe::Charge.create(
      amount: @coin_pack.amount,
      customer: @customer.id,
      description: @coin_pack.description,
      currency: 'usd'
    )

    current_user.increment_coins! @coin_pack.coins

    # Send a receipt
    OrderMailer.receipt(current_user.id, @charge.id, @coin_pack.id).deliver

    track(current_user.distinct_id, 'Paid',
      'coin pack' => @coin_pack.id,
      'amount'    => @charge.amount
    )

    engage(current_user.distinct_id,
      '$add' => {
        'Time'  => @coin_pack.coins,
        'Spent' => @charge.amount
      },
      '$append' => {
        '$transactions' => {
          '$time' => Time.now.utc.iso8601,
          '$amount' => (@charge.amount / 100.0)
        }
      }
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to pricing_page_path
  end

end
