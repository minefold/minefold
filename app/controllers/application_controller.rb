class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  extend StatsD::Instrument

  def not_found
    render template: 'errors/not_found', status: :not_found
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

  def mixpanel
    @mixpanel ||= EM::Mixpanel.new(ENV['MIXPANEL_TOKEN'], ip: request.ip)
  end

  def track(event_name, properties={})
    if Rails.env.production?
      if signed_in?
        properties[:distinct_id] = current_user.id.to_s
        properties[:mp_name_tag] = current_user.safe_username
      end

      mixpanel.track(event_name, properties)
    else
      Rails.logger.info "[Mixpanel] <#{event_name}> #{properties}"
    end
  end

end
