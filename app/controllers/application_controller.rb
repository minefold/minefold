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

private
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
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

end
