class OrdersController < ApplicationController
  def purchase_time
    new_hours = params[:user][:hours].to_i
    current_user.buy_hours! new_hours
    redirect_to user_root_path, notice: "You purchased #{new_hours} new hours"
  end
  
  def subscribe
    current_user.update_attributes! params[:user]
    new_plan = Plan.find(params[:user][:plan_id])
    redirect_to user_root_path, notice: "Plan changed to #{new_plan.name}"
  end

end
