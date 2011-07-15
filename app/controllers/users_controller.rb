class UsersController < ApplicationController

  def dashboard
    @worlds = World.recently_active.limit(3 * 4)

    # @stream = user.world.wall_items
  end

  def new
    @user = User.new
    render layout: 'system'
  end

  def create
    @user = User.new params[:user]

    if @user.valid? && @user.save
      warden.set_user @user
      redirect_to dashboard_path
    else
      flash[:errors] = @user.errors
      render :new, layout: 'system'
    end
  end

end
