require 'base64'
require 'hmac-sha1'

class Webhooks::HelpScoutController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_webhook
  layout nil

  def create
    data = JSON.parse(request.body.read)
    email = data['customer']['email']
    @user = User.find_by_email(email)

    if @user
      render json: {
        html: render_to_string(layout: nil)
      }
    else
      render :status => :not_found, :nothing => true
    end
  end

  def verify_webhook
    data = request.body.read
    signature = request.headers['X-HelpScout-Signature']

    if data && signature && valid_signature?(data, signature)
      request.body.rewind
    else
      render :status => :unauthorized, :nothing => true
    end
  end

  def valid_signature?(data, signature)
    hmac = HMAC::SHA1.new(ENV['HELPSCOUT_SECRET'])
    hmac.update(data)
    Base64.encode64(hmac.digest.to_s).strip ==
      signature.strip
  end

end
