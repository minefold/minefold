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
    current_user.update_attributes! params[:user]
    redirect_to case
      when params[:plan]
        account_plan_path(params[:plan])

      when params[:hours]
        account_time_pack_path(params[:hours])
      else
    end
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


protected

  def require_card!
    if not current_user.customer? or not current_user.card?
      if params[:stripe_token]
        current_user.stripe_token = params[:stripe_token]
        current_user.create_customer
        current_user.save
      else
        # This amount that will be guarenteed by Stripe
        @amount = StripeController::AMOUNTS[params[:plan_id] || params[:hours]]

        render controller: :stripe, action: :new, status: :payment_required
      end
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

    # UserMailer.payment_failed(@user.id).deliver!

    render nothing: true, status: :success
  end

  def ping_hook(params)
    render nothing: true, status: :success
  end

end
