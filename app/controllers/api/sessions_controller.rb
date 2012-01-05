class Api::SessionsController < ApplicationController
  before_filter -> {
    @current_user = authenticate_with_http_basic do |username, password|
      user = User.by_email_or_username(username).first
      user if user && user.valid_password?(password)
    end
  }
  
  def create
    if current_user
      render status: 200, layout: false, nothing: true
    else
      render status: 500, layout: false, nothing: true
    end
  end
end
