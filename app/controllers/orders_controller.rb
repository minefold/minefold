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
      track 'paid', amount: order.total
      
      engage order.user.id, '$add' => {
        'cents spent' => order.total,
        'credits'     => order.credits
      }
      
      CreditsMailer.receipt(
        order.user.id,
        order.charge_id,
        order.credit_pack_id
      ).deliver
      
      redirect_to user_root_path,
        notice: "Thank you for buying Minefold credits"
    else
      render nothing: true, :status => :payment_required
    end
  end

end
