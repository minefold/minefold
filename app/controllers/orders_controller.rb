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
    new_plan = Plan.find(params[:user][:plan_id])
    redirect_to params[:return_url], notice: "Plan changed to #{new_plan.name}"
  end

end
