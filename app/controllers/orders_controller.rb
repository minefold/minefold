class OrdersController < ApplicationController
  
  def purchase
    
  end
  
  def subscribe
    current_user.plan = params[:plan_id]
    current_user.save

    redirect_to :back
  end
  
  
  def create
    current_user.update_attributes! params[:user]
    redirect_to params[:return_url]
  end

end
