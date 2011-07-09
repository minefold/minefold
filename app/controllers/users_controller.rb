class UsersController < ApplicationController

  def dashboard
    @worlds = World.all
    @world = World.new
  end

  def new
    @user = User.new
    render layout: 'system'
  end

  def create
    @user = User.new params[:user]

    p @user

    if @user.valid? && @user.save

      p @user

      warden.set_user @user
      redirect_to dashboard_path
    else
      flash[:errors] = @user.errors
      render :new, layout: 'system'
    end
  end

end
