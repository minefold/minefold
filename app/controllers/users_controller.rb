class UsersController < ApplicationController

  layout 'application', only: [:dashboard]

  def dashboard
    @worlds = World.all
    @world = World.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.first invite: params[:user].delete(:invite)
    raise User::InvalidInvite unless @user

    @user.claim_invite

    @user.update_attributes params[:user]

    if @user.valid? && @user.save
      warden.set_user @user
      redirect_to dashboard_path
    else
      flash[:errors] = @user.errors
      render :new
    end
  end

end
