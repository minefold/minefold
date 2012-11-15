class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound,
              ActiveRecord::StatementInvalid,
              ActionController::RoutingError do
    render status: :not_found, template: 'errors/not_found'
  end

  rescue_from CanCan::AccessDenied do
    render status: :unauthorized, text: 'unauthorized'
  end

  before_filter :set_mixpanel_distinct_id

private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  # --

  def set_mixpanel_distinct_id
    if mixpanel_cookie.present?
      begin
        distinct_id = JSON.parse(mixpanel_cookie)['distinct_id']
        session['distinct_id'] = distinct_id
      rescue JSON::ParserError => e
        logger.warn("Exception parsing Mixpanel cookie")
      end
    end
  end

  def track(event, properties={})
    properties[:time]        ||= Time.now.to_i
    properties[:ip]          ||= request.ip
    properties[:distinct_id] ||= current_user.distinct_id if signed_in?

    Mixpanel.track_async(event, properties)
  end

  def engage(distinct_id, properties={})
    Mixpanel.engage_async(distinct_id, properties)
  end

  def mixpanel_cookie
    request.cookies['mp_mixpanel']
  end

end
