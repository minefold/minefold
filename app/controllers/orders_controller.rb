class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout false
  
  def new
    @credit_packs = CreditPack.active.all.sort_by {|p| p.cents }
  end
  
  def create
    order = Order.new(
      params[:credit_pack_id],
      current_user,
      params[:stripe_token]
    )

    if order.valid? and order.fulfill
      track 'paid', total: order.total,
                    cr: order.credits

      CreditsMailer.receipt(order.user, order.charge_id).deliver

      redirect_to user_root_path,
        notice: "Thank you for buying #{order.credits} credits on Minefold"

    else
      render nothing: true, :status => :payment_required
    end
  end

end
