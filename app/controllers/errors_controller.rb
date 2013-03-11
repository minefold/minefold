class ErrorsController < ApplicationController
  layout 'clean'

  def not_found
    render :status => :not_found
  end

  def server_error
    render :status => :server_error
  end

end
