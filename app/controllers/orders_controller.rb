class OrdersController < ApplicationController
  
  def create
    # TODO: Validate that this exists
    current_user.stripe_token = params[:stripe_token]
    
    pack = TimePack.find(params[:user][:hours].to_i)
    current_user.buy_time! pack
    
    track 'paid', hours: pack.hours, amount: pack.amount
    
    # TODO: Pluralisation
    redirect_to user_root_path, notice: "Thank you for buying #{pack.hours} hours"
  end

end
