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
      track 'Paid', 'distinct_id' => order.user.distinct_id,
                    'coin pack' => order.coin_pack.id,
                    'amount'      => order.total

      mixpanel_person_add order.user.distinct_id, 'Spent' => order.total

      # Send a receipt
      CoinsMailer.receipt(
        order.user.id,
        order.charge_id,
        order.coin_pack.id
      ).deliver

      redirect_to(order)
    else
      render nothing: true, :status => :payment_required
    end
  end

  def show
    authorize! :read, order
  end

end
