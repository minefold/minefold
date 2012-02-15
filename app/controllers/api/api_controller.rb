class Api::ApiController < ActionController::Base
  include Mixpanel

  before_filter :http_auth
  layout nil

  def key
    render json: { api_key: current_user.authentication_token }
  end

  def http_auth
    @current_user = authenticate_with_http_basic do |username, password|
      user = User.by_email_or_username(username).first
      user if user && user.valid_password?(password)
    end

    render status: :unauthorized, text: "HTTP Basic Auth required" unless @current_user
  end

  def api_key_auth
    @current_user = User.where(authentication_token: request.headers['Api-key']).first
    render status: 403, text: "API key required" unless @current_user
  end

end