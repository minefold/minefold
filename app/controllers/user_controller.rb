class UserController < ApplicationController

  def dashboard
    @worlds = World.all
    @world = World.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.first :invite => params[:user].delete(:invite)
    raise User::InvalidInvite unless @user
    @user.invite = nil
    @user.update_attributes params[:user]


    if @user.valid? && @user.save
      env['warden'].set_user @user

      redirect_to :root
    else
      flash[:errors] = @user.errors
      render :new
    end
  end

end
