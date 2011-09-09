class UsersController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [:new, :create]

  include Devise::Controllers::InternalHelpers

  # prepend_before_filter :require_no_authentication, :only => [:new, :create]

  # prepend_before_filter :authenticate_user!

  expose(:user) {User.find_by_slug!(params[:id])}

  def show
  end

  def dashboard
    @worlds = World.visible.order_by(:slug).all
  end

  def new
    @user = User.new
  end

  def create
    @referral = Referral.where(code: params[:code]).first!
    
  end

  def edit
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to user_root_path
  end

protected

def require_no_authentication
  no_input = devise_mapping.no_input_strategies
  args = no_input.dup.push :scope => resource_name
  if no_input.present? && warden.authenticate?(*args)
    resource = warden.user(resource_name)
    flash[:alert] = I18n.t("devise.failure.already_authenticated")
    redirect_to after_sign_in_path_for(resource)
  end
end

end
