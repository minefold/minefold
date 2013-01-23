class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!

  expose(:order) {
    Order.find_from_charge(params[:id])
  }

  def create
    order = Order.new(
      current_user,
      params[:coin_pack_id],
      params[:stripe_token]
    )

    if order.valid? and order.fulfill
      # Do all our amazing tracking stuff
      track order.user.distinct_id, 'Paid',
        'coin pack' => order.coin_pack.id,
        'amount'    => order.total

      # Send a receipt
      OrderMailer.receipt(
        order.user.id,
        order.charge_id,
        order.coin_pack.id
      ).deliver

      MixpanelAsync.engage(order.user.distinct_id, {
        '$set' => {
          'Spent' => order.total
        },
        '$append' => {
          '$transactions' => {
            '$time' => Time.now.utc.iso8601,
            '$amount' => (order.total / 100.0)
          }
        }
      })

      redirect_to(order)
    else
      render nothing: true, :status => :payment_required
    end
  end

  def show
    authorize! :read, order
  end

end
