class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  extend StatsD::Instrument

  def track(event_name, properties={})
    if current_user
      properties[:distinct_id] = current_user.id.to_s
      properties[:mp_name_tag] = current_user.safe_username
    end

    mixpanel.track(event_name, properties)
  end


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
    @mixpanel ||= Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'], request.env)
  end

  # def require_customer!
  #   if not current_user.customer
  #     if params[:stripe_token]
  #       current_user.stripe_token = params[:stripe_token]
  #       current_user.create_customer
  #       current_user.save
  #     else
  #       # This amount that will be guarenteed by Stripe
  #       @amount = StripeController::AMOUNTS[params[:plan_id] || params[:hours]]
  #
  #       render controller: :stripe, action: :new, status: :payment_required
  #     end
  #   end
  # end

end
