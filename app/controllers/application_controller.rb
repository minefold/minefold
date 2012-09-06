class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid do
    render status: :not_found, template: 'errors/not_found'
  end

  rescue_from CanCan::AccessDenied do
    render status: :unauthorized, text: 'unauthorized'
  end

private

  def track(event_name, properties={})
    Resque.enqueue(MixpanelJob, event_name, properties)
  end

end
