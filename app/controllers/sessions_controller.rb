class SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    authenticate!
    user.remember!

    p user.remember_token

    cookies.signed['remember_token'] = user.remember_token
    redirect_to dashboard_path
  end

  def destroy
    logout
    redirect_to new_session_path
  end

  def unauthenticated
    @user = User.new email: params[:user][:email]
  end

end
