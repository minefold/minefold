class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from User::Unauthenticated, with: :unauthenticated
  rescue_from MongoMapper::DocumentNotFound, with: :not_found

private

  def require_authentication
    raise User::Unauthenticated unless authenticated?
  end

  def require_no_authentication
    redirect_to(dashboard_url) if authenticated?
  end

  def not_found
    render file: '404.html', status: 404
  end

  def unauthenticated
    render text: 'foo'
  end

end
