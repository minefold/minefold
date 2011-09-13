class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  extend StatsD::Instrument  

private

  # TODO Design
  def not_found
    render text: "<strong>404</strong><br/>All that is here is a sad panda surrounded by the remains of his beautiful world and the omnious hiss of a creeper ringing in his ears. :(", status: :not_found
  end

end
