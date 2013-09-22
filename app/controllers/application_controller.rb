class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError do
    render status: :not_found, template: 'errors/not_found'
  end

  rescue_from CanCan::AccessDenied do
    render status: :unauthorized, text: 'unauthorized'
  end

  before_filter :set_invitation_token
  before_filter :set_timezone
  before_filter :warn_unconfirmed
  before_filter :show_shutdown_message

  before_bugsnag_notify :add_user_info_to_bugsnag

private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    flash[:signed_in] = true
    stored_location_for(resource) || super
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

# --

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
    if signed_in? and not current_user.confirmed?
      flash[:salert] = :unconfirmed
    end
  end

  def show_shutdown_message
    flash[:notice] = "Minefold is shutting down on #{Date.parse(ENV['SHUTDOWN']).to_s(:short)} – <a href=\"http://blog.minefold.com\" target=\"_blank\">Read More</a>".html_safe
  end

end
