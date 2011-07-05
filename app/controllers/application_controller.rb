class ApplicationController < ActionController::Base
  protect_from_forgery

private

  def require_no_authentication
    redirect_to(dashboard_url) if authenticated?
  end

end
