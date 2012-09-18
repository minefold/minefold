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
  
  def track(event_name, properties={})
    Resque.enqueue(MixpanelJob, event_name, properties)
  end

end
