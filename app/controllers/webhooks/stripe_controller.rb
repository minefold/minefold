class Webhooks::StripeController < ApplicationController
  protect_from_forgery :except => :process

  def create
    Librato.increment('webhook.stripe.total')

    event = JSON.parse(request.body.read, symbolize_names: true)
    
    p event
    
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

  def method_missing(name, args)
    # ignore stripe events we're not handling
  end
end
