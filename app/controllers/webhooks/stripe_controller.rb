class Webhooks::StripeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # Validate Stripe event
    data = JSON.parse(request.body.read)
    event = Stripe::Event.retrieve(data['id'])

    Librato.increment('webhook.stripe.total')
    Scrolls.log(stripe_event: event[:id], type: event[:type])

    case event[:type]
    when 'ping'
      ping(event)
    when 'customer.subscription.created'
      customer_subscription_created(event)
    when 'charge.succeeded'
      charge_succeeded(event)
    end

    render nothing: true, status: 200
  end

# --

  def ping(event)
    Librato.increment('stripe.ping.total')
  end

  def customer_subscription_created(event)
    Librato.increment('stripe.customer_subscription_created.total')
  end

  def charge_succeeded(event)
    Librato.increment('stripe.charge_succeeded.total')

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

end
