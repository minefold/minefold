class StripeController < ApplicationController

  EVENTS = %W(
    invoice_ready
    ping
    recurring_payment_failed
    recurring_payment_succeeded
    subscription_final_payment_attempt_failed
    subscription_trial_ending
  )

  protect_from_forgery except: [:webhook]

  def webhook
    event = params.delete(:event)
    customer_id = params.delete(:customer)

    if EVENTS.include?(event) && @user = User.by_stripe_id(customer_id).first
      send("#{event}_hook")
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

private
  
  def invoice_ready_hook
    render nothing: true, status: :success
  end
  
  def ping_hook
    render nothing: true, status: :success
  end
  
  def recurring_payment_failed_hook
    render nothing: true, status: :success
  end
  
  def recurring_payment_succeeded_hook
    render nothing: true, status: :success
  end
  
  def subscription_final_payment_attempt_failed_hook
    render nothing: true, status: :success
  end
  
  def subscription_trial_ending_hook
    render nothing: true, status: :success
  end
  
end
