class HomeController < ApplicationController

  def index
    if user_signed_in?
      @worlds = World.all
      render :dashboard
    else
      render :index
    end
  end

end
