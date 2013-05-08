class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError do
    render status: :not_found, template: 'errors/not_found'
  end

  rescue_from CanCan::AccessDenied do
    render status: :unauthorized, text: 'unauthorized'
  end

  before_filter :set_mixpanel_distinct_id
  before_filter :set_invitation_token
  before_filter :set_timezone
  before_filter :warn_unconfirmed

  before_bugsnag_notify :add_user_info_to_bugsnag

private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if cookies[:last_viewed_server_id]
        server_path(cookies[:last_viewed_server_id])
      else
        super
      end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

# --

  def set_mixpanel_distinct_id
    if mixpanel_cookie.present?
      begin
        distinct_id = JSON.parse(mixpanel_cookie)['distinct_id']

        # This is in the case where for some reason the user has been created *without* a distinct_id but Mixpanel has assigned one.
        if signed_in? and current_user.distinct_id.nil?
          current_user.update_attribute :distinct_id, distinct_id
        else
          session['distinct_id'] ||= distinct_id
        end

      rescue JSON::ParserError => e
        logger.warn("Exception parsing Mixpanel cookie")
      end
    end
  end

  def set_invitation_token
    if token = (params[:invitation_token] || params[:i])
      session[:invitation_token] = token
    end
  end

  def add_user_info_to_bugsnag(notifier)
    if signed_in?
      notifier.add_tab(:user, id: current_user.id,
                              email: current_user.email,
                              username: current_user.username)
    end
  end

  def set_timezone
    min = (request.cookies["time_zone"] || 0).to_i
    Time.zone = ActiveSupport::TimeZone[-min.minutes]
  end

  def warn_unconfirmed
    if current_user and !current_user.confirmed?
      flash[:notice] = "A message with a confirmation link has been sent to your email address. Please open the link to activate your account. <a href=\"/resend_confirmation\">Resend confirmation</a>".html_safe
    end
  end


# --

  def track(distinct_id, event, properties={})
    properties[:time]        ||= Time.now.utc.to_i
    properties[:ip]          ||= request.ip
    MixpanelAsync.track(distinct_id, event, properties)
  end

  def engage(distinct_id, properties={})
    MixpanelAsync.engage(distinct_id, properties)
  end

  def mixpanel_cookie
    request.cookies['mp_mixpanel']
  end

end
