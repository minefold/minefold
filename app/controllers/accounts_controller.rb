class AccountsController < ApplicationController

  prepend_before_filter :authenticate_user!

  def dashboard
    @worlds = World.available_to_play.sort(:slug)
  end

  def edit
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to user_root_path
  end

end
