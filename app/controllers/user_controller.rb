class UserController < ApplicationController

  def show
  end

  def create
    @user = User.create! params[:user]
    redirect_to :root
  end

end
