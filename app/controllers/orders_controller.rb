class OrdersController < ApplicationController
  def purchase_time
    pack = TimePack.find(params[:user][:hours].to_i)

    current_user.buy_time_pack! pack

    track 'paid', hours: pack.hours, amount: pack.price

    redirect_to user_root_path, notice: "You purchased #{pack.hours} hours"
  end

  def subscribe
    current_user.update_attributes! params[:user]
    new_plan = Plan.find(params[:user][:plan_id])
    redirect_to user_root_path, notice: "Plan changed to #{new_plan.name}"
  end

end
