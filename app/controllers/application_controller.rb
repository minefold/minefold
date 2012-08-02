class ApplicationController < ActionController::Base
  # extend StatsD::Instrument

  protect_from_forgery

  class NotFound < StandardError; end

  rescue_from Mongoid::Errors::DocumentNotFound, NotFound do
    render status: :not_found, template: 'errors/not_found'
  end

  rescue_from CanCan::AccessDenied do
    render status: :unauthorized, text: 'unauthorized'
  end

  before_filter :require_player_verification

private

  def track(event_name, properties={})
    Resque.enqueue(MixpanelJob, event_name, properties)
  end

  def require_no_authentication!
    no_input = devise_mapping.no_input_strategies
    args = no_input.dup.push(:scope => :user)
    if no_input.present? && warden.authenticate?(*args)
      resource = warden.user(:user)
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(resource)
    end
  end

  def require_player_verification
    if signed_in? and not current_user.verified?
      redirect_to verify_user_path
    end
  end

end
