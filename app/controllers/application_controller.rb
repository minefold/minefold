class ApplicationController < ActionController::Base
  class NotFound < StandardError; end

  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid, Mongoid::Errors::DocumentNotFound, NotFound do
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
