class HomeController < ApplicationController

  def index
    if user_signed_in?
      @worlds = World.all
      render :dashboard
    else
      @user = User.new
      render :index
    end
  end

end
