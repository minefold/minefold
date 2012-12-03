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

  before_bugsnag_notify :add_user_info_to_bugsnag

private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
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
    if params[:invitation_token]
      session[:invitation_token] = params[:invitation_token]
    end
  end

  def add_user_info_to_bugsnag(notifier)
    notifier.add_tab :user, id: current_user.id,
                            email: current_user.email,
                            username: current_user.username
  end


# --

  def track(event, properties={})
    properties[:time]        ||= Time.now.to_i
    properties[:ip]          ||= request.ip
    properties[:distinct_id] ||= current_user.distinct_id if signed_in?

    Mixpanel.async_track(event, properties)
  end

  def mixpanel_person_set(distinct_id, properties={})
    Mixpanel.async_person_set(distinct_id, properties)
  end

  def mixpanel_person_add(distinct_id, properties={})
    Mixpanel.async_person_add(distinct_id, properties)
  end

  def mixpanel_cookie
    request.cookies['mp_mixpanel']
  end

end
