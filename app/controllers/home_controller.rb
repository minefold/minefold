class HomeController < ApplicationController

  def teaser
  end

  def subscribe
    user = BetaUser.create email: params[:beta_user][:email]
    flash[:email] = user.email

    redirect_to root_path
  end

end
