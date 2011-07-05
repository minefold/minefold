class SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    authenticate!
    redirect_to dashboard_path
  end

  def destroy
    logout
    redirect_to new_session_path
  end

  def unauthenticated
    flash[:foo] = 'sad panda'
    redirect_to new_session_path
  end

end
