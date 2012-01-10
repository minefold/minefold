class ApplicationController < ActionController::Base
  extend StatsD::Instrument
  include Mixpanel

  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound do
    render status: :not_found, template: 'errors/not_found'
  end

  rescue_from(CanCan::AccessDenied) do
    render status: :unauthorized, nothing: true
  end

private

  def require_no_authentication!
    no_input = devise_mapping.no_input_strategies
    args = no_input.dup.push(:scope => :user)
    if no_input.present? && warden.authenticate?(*args)
      resource = warden.user(:user)
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(resource)
    end
  end

end
