class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from MongoMapper::DocumentNotFound, with: :not_found

private

  def not_found
    render file: '404.html', status: 404
  end

end
