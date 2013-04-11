class Webhooks::StripeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    Librato.increment('webhook.stripe.total')

    data = JSON.parse(request.body.read)
    
    p data
    
    # validate stripe event
    event = Stripe::Event.retrieve(data['id'])
    
    method = event[:type].gsub('.', '_')
    self.send method, event

    render nothing: true, status: 200
  end
  
  def ping(event)
    Librato.increment('stripe.ping.total')
  end
  
  def charge_succeeded(event)
    charge = event[:data][:object]
    user = User.find_by_customer_id(charge[:customer])
    SubscriptionMailer.receipt(user.id, charge[:id])
  end

  def method_missing(meth, *args, &block)
    # ignore stripe events we're not handling
  end
end
