class AdminController < ApplicationController

  before_filter :authenticate

  def index
    @users = User.all(:sort => :created_at.asc)
    @beta_users = BetaUser.all(:sort => :created_at.asc)
    render :layout => false
  end

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "carlsmum"
    end
  end

end
