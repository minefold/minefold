require 'openssl'

class Webhooks::MailgunController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_webhook

  def create
    Librato.increment('webhook.mailgun.total')

    case params['event']
    when 'opened'
      Librato.increment('mailgun.opened.total')
      opened(params)

    when 'clicked'
      Librato.increment('mailgun.clicked.total')
      clicked(params)

    when 'unsubscribed'
      Librato.increment('mailgun.unsubscribed.total')
      unsubscribed(params)

    when 'complained'
      Librato.increment('mailgun.complained.total')
      complained(params)

    when 'bounced'
      Librato.increment('mailgun.bounced.total')
      bounced(params)

    when 'dropped'
      Librato.increment('mailgun.dropped.total')
      dropped(params)

    when 'delivered'
      Librato.increment('mailgun.delivered.total')
      delivered(params)
    end

    render nothing: true, status: 200
  end

  def opened(params)
  end

  def clicked(params)
  end

  def unsubscribed(params)
  end

  def complained(params)
  end

  def bounced(params)
  end

  def dropped(params)
  end

  def delivered(params)
  end


# private

  def verify_webhook
    if not secure?(ENV['MAILGUN_API_KEY'], params.fetch(:token), params.fetch(:timestamp), params.fetch(:signature))
      render nothing: true, status: 403
    end

    # In place of Rails 4.0 strong params
  rescue KeyError
    render nothing: true, status: 403
  end

  def secure?(api_key, token, timestamp, signature)
    digest = OpenSSL::Digest::Digest.new('sha256')
    data = [timestamp, token].join
    signature == OpenSSL::HMAC.hexdigest(digest, api_key, data)
  end

end
