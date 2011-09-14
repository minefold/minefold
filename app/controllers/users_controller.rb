class UsersController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [:new, :create]

  include Devise::Controllers::InternalHelpers

  # prepend_before_filter :require_no_authentication, :only => [:new, :create]

  # prepend_before_filter :authenticate_user!

  def show
  end

  def dashboard
    @worlds = World.visible.order_by(:slug).all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in :user, @user
      respond_with @user, :location => stored_location_for(:user) || user_root_path
    else
      clean_up_passwords(@user)
      respond_with @user, :location => users_path
    end
  end

  def edit
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to user_root_path
  end

end
