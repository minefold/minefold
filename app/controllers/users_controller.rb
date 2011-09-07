class UsersController < ApplicationController

  # prepend_before_filter :authenticate_user!

  expose(:user) {User.find_by_slug!(params[:id])}

  def show
  end

  def dashboard
    @worlds = World.visible.order_by(:slug).all
  end

  def edit
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to user_root_path
  end

end
