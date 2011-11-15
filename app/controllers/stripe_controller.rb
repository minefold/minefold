class StripeController < ApplicationController

  EVENTS = %W(
    recurring_payment_failed
    invoice_ready
    recurring_payment_succeeded
    subscription_trial_ending
    subscription_final_payment_attempt_failed
    ping
  )

  # TODO: Refactor
  AMOUNTS = {
    '10'  => 295,
    '40'  => 795,
    '120' => 1195
  }

  protect_from_forgery except: [:webhook]

  respond_to :html

  # Renders page that gets the card token
  def new
  end
  
  def create
    
  end

  before_filter :require_customer!, only: [:charge, :subscription]

  def charge
    # TODO: Check that the hours exist in AMOUNTS
    current_user.buy_hours! AMOUNTS[params[:hours]], params[:hours].to_i

    redirect_to billing_account_path
  end

  def subscribe
    current_user.update_attribute :plan_id, params[:plan_id]

    redirect_to billing_account_path
  end

  def unsubscribe
    current_user.update_attribute :plan_id, nil

    redirect_to billing_account_path
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
    subscriptions = params['invoice']['lines']['subscriptions']
    plan_id = subscriptions.first['plan']['id']

    @user.recurring_payment_succeeded! plan_id

    render nothing: true, status: :success
  end

  def recurring_payment_failed_hook(params)

    @user.recurring_payment_failed! params['attempt'].to_i

    UserMailer.payment_failed(@user.id).deliver!

    render nothing: true, status: :success
  end

  def ping_hook(params)
    render nothing: true, status: :success
  end

end
