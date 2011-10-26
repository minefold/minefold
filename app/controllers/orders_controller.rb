class OrdersController < ApplicationController

  def new
    # @order = Order.new
  end

  def create
    current_user.stripe_token = params[:stripe_token]
    current_user.plan = params[:plan]
    
    current_user.save

    redirect_to user_root_path
    # @order = Order.new(params[:order])

    # @order.user = current_user
    #
  end

end
