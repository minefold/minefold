class Api::ApiController < ActionController::Base
  include Mixpanel
  
  before_filter -> {
    @current_user = authenticate_with_http_basic do |username, password|
      user = User.by_email_or_username(username).first
      user if user && user.valid_password?(password)
    end
        
    render status: 500, layout: false, nothing: true unless @current_user
  }
end