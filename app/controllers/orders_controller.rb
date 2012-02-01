class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!
  
  def create
    return payment_required! unless params[:stripe_token] and params[:pack_id]
    
    pack = TimePack.find params[:pack_id]
    
    return payment_required! unless pack
    
    if current_user.buy_pack!(params[:stripe_token], pack)
      track 'paid', months: pack.months, amount: pack.cents
      redirect_to user_root_path, notice: "Thank you for buying #{pack.months} of Minefold Pro"
    else
      payment_required!
    end
  end
  
private

  def payment_required!
    render(nothing: true, status: :payment_required)
  end

end
