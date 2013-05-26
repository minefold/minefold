class SubscriptionsController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    @plan = Plan.find(params[:plan_id])

    @subscription = current_user.subscribe!(@plan, params[:stripeToken], params[:last4], params[:tradein])

    redirect_to thank_you_subscriptions_path

  rescue Stripe::CardError => e
    flash[:message] = e.message
    flash[:alert] = :card_error
    redirect_to plans_page_path
  end

  def update
    current_user.update_card!(params[:stripeToken], params[:last4])

    redirect_to edit_user_registration_path
  end

end
