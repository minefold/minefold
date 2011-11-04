class StripeController < ApplicationController

  EVENTS = %W(
    recurring_payment_failed
    invoice_ready
    recurring_payment_succeeded
    subscription_trial_ending
    subscription_final_payment_attempt_failed
    ping)

  protect_from_forgery except: [:webhook]

  # Renders page that gets the card token
  def new
  end

  # Creates a new customer/plan from the given tokens
  def create
    current_user.stripe_token = params[:stripe_token]
    current_user.plan = params[:plan]
    current_user.save

    respond_with current_user
  end

  # Handles any changes to plans
  def update
    current_user.plan = params[:plan]
    current_user.save

    respond_with current_user
  end

  # Processes Stripe webhooks
  def webhook
    event = params.delete(:event)
    customer_id = params.delete(:customer)
    
    if EVENTS.include?(event) && @user = User.by_stripe_id(customer_id).first
      send("#{event}_hook", params)
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

private

  def recurring_payment_succeeded_hook(params)
    # # TODO
    # UserMailer.invoice(@user.id, @invoice.id).deliver!
    @user.renew_subscription!
    
    render nothing: true, status: :success
  end

  def recurring_payment_failed_hook(params)
    @user.last_payment_succeeded = false
    @user.save!
    
    UserMailer.payment_failed(@user.id).deliver!

    render nothing: true, status: :success
  end

  def ping_hook(params)
    render nothing: true, status: :success
  end

end
