class OrdersController < ApplicationController

  def new
    @plan = Plan.find(params[:plan])
    not_found unless @plan
  end

  def create
    unless Plan.find(params[:plan]).free?
      raise 'Missing card token' unless params[:stripe_token] or current_user.has_card?
      current_user.stripe_token = params[:stripe_token]
    end

    current_user.plan = params[:plan]
    current_user.save

    redirect_to user_root_path
  end

end
