class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    order = Order.new(
      params[:credit_pack_id],
      current_user,
      params[:stripe_token]
    )

    if order.valid? and order.fulfill
      track 'paid', total: order.total,
                    cr: order.credits

      # TODO Send Receipt

      redirect_to user_root_path,
        notice: "Thank you for buying #{order.credits} credits on Minefold"

    else
      render nothing: true, :status => :payment_required
    end
  end

end
