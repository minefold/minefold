class TimePacksController < ApplicationController
  expose(:pack) { TimePack.find(params[:id].to_i) }
  
  before_filter :require_customer_if_paid

  def require_customer_if_paid
    redirect_to customer_new_path(hours: pack.hours) unless current_user.customer
  end
end