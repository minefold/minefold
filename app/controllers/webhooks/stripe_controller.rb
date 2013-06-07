class Webhooks::StripeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # Validate Stripe event
    data = JSON.parse(request.body.read)
    event = Stripe::Event.retrieve(data['id'])

    Librato.increment('webhook.stripe.total')
    Librato.increment("stripe.#{event[:type]}.total")

    Scrolls.log(stripe_event: event[:id], type: event[:type])

    case event[:type]
    when 'ping'
      ping(event)
    when 'customer.subscription.created'
      customer_subscription_created(event)
    when 'charge.succeeded'
      charge_succeeded(event)
    when 'invoice.payment_failed'
      invoice_payment_failed(event)
    end

    render nothing: true, status: 200
  end

# --

  def ping(event)
  end

  def customer_subscription_created(event)
  end

  def charge_succeeded(event)
    charge = event[:data][:object]

    user = User.find_by_customer_id(charge[:customer])
    user.charge_succeeded!

    SubscriptionMailer.receipt(user.id, charge[:id]).deliver

    revenue = charge[:amount] / 100

    Analytics.track(
      user_id: user.id,
      event: 'Paid',
      properties: {
        revenue: revenue
      }
    )
  end

  def invoice_payment_failed
    invoice = event[:data][:object]

    user = User.find_by_customer_id(invoice[:customer])
    user.payment_failed!

    if invoice.closed
      SubscriptionMailer.payment_failed_permanently(user.id, invoice[:id]).deliver
    else
      SubscriptionMailer.payment_failed(user.id, invoice[:id]).deliver
    end
  end

end
