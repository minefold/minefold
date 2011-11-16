class PlansController < ApplicationController
  expose(:plan) { Plan.find(params[:id]) || Plan.free }
  
  before_filter :require_customer_if_paid

  def require_customer_if_paid
    if plan.price > 0 and not current_user.customer
      redirect_to customer_new_path(plan: plan.id)
    end
  end
end