class StripeController < ApplicationController

  EVENTS = [
    :recurring_payment_failed,
    :invoice_ready,
    :recurring_payment_succeeded,
    :subscription_trial_ending,
    :subscription_final_payment_attempt_failed,
    :ping
  ]

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
    customer_id = params.delete(:customer_id)
    if EVENTS.include?(event)
      @user = User.by_stripe_id(customer_id).first
      send("#{event}_hook", params)
    else
      render status: :unprocessable_entity
    end
  end

private

  def recurring_payment_succeeded_hook(params)
    @invoice = Invoice.new(params[:invoice])
    @invoice.payment.new(params[:payment])
    @user.push :invoices, @invoice

    # TODO
    UserMailer.invoice(@user.id, @invoice.id).deliver!

    render status: :success
  end

  def recurring_payment_failed_hook(params)
    @invoice = Invoice.new(params[:invoice])
    @invoice.payment.new(params[:payment])
    @user.push :invoices, invoice

    # TODO
    UserMailer.payment_failed(@user.id, @invoice.id).deliver!

    render status: :success
  end

  def subscription_final_payment_attempt_failed_hook(params)
    @user.plan = nil
    @user.save

    # TODO
    UserMailer.final_payment_failed(@user.id).deliver!

    render status: :success
  end


  def invoice_ready_hook(params)
    render json: {invoiceitems: []}
  end

  def subscription_trial_ending_hook(params)
    render status: :success
  end

  def ping_hook(params)
    render status: :success
  end

end
