class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  extend StatsD::Instrument

private

  # TODO Design
  def not_found
    render text: "<strong>404</strong><br/>All that is here is a sad panda surrounded by the remains of his beautiful world and the omnious hiss of a creeper ringing in his ears. :(", status: :not_found
  end

  def require_no_authentication
    no_input = devise_mapping.no_input_strategies
    args = no_input.dup.push :scope => :user
    if no_input.present? && warden.authenticate?(*args)
      resource = warden.user(:user)
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(resource)
    end
  end

end
