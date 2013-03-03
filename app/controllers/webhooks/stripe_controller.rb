class Webhooks::StripeController < ApplicationController
  protect_from_forgery :except => :process

  def create
    Librato.increment('webhook.stripe.total')

    case params['type']
    when 'ping'
      Librato.increment('stripe.ping.total')
      ping(params)
    end
  end

  def ping(event)
    render nothing: true, status: 200
  end

end
