class HomeController < ApplicationController

  def teaser
    redirect_to user_root_path if signed_in?
  end

end
