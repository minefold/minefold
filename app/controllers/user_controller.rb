class UserController < ApplicationController

  def dashboard
    @worlds = World.all
    @world = World.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_invite! params[:user].delete(:invite)
    @user.claim_invite

    @user.update_attributes params[:user]

    if @user.valid? && @user.save
      env['warden'].set_user @user

      redirect_to dashboard_path
    else
      flash[:errors] = @user.errors
      render :new
    end
  end

end
