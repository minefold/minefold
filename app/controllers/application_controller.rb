class ApplicationController < ActionController::Base
  extend StatsD::Instrument
  include Mixpanel

  protect_from_forgery

  class NotFound < StandardError; end

  rescue_from Mongoid::Errors::DocumentNotFound, NotFound do
    render status: :not_found, template: 'errors/not_found'
  end

  rescue_from CanCan::AccessDenied do
    render status: :unauthorized, text: 'unauthorized'
  end

  before_filter do
    if signed_in?
      Exceptional.context user_id: current_user.id,
                          email: current_user.email
    end
  end

  before_filter :require_username!

  before_filter :set_mpid

private

  def set_mpid
    if not cookies[:mpid]
      mpid = signed_in? ? current_user.mpid : User.mpid
      cookies[:mpid] = {value: mpid, expires: 1.year.from_now}
    end
  end

  def require_no_authentication!
    no_input = devise_mapping.no_input_strategies
    args = no_input.dup.push(:scope => :user)
    if no_input.present? && warden.authenticate?(*args)
      resource = warden.user(:user)
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(resource)
    end
  end

  def require_username!
    if signed_in? and current_user.username.nil?
       redirect_to username_account_path
    end
  end

end
