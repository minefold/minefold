class HomeController < ApplicationController

  def teaser
  end

  def subscribe
    user = User.create email: params[:user][:email]
    flash[:email] = user.email

    redirect_to root_path
  end

end
