class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!
  
  def create
    # TODO: When we start modifying the TimePacks we need to have actual IDs for them. If we change the price of a pack while somebody is on the checkout page they could get a nasty surprise with their bill.
    return payment_required! unless params[:stripe_token] and params[:hours]
    
    pack = TimePack.find(params[:hours].to_i)
    
    return payment_required! unless pack
    
    if current_user.buy_time!(params[:stripe_token], pack)
      track 'paid', hours: pack.hours, amount: pack.amount
      redirect_to user_root_path, notice: "Thank you for buying #{pack.hours} hours"
    else
      payment_required!
    end
  end
  
private

  def payment_required!
    render(nothing: true, status: :payment_required)
  end

end
