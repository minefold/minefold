class HomeController < ApplicationController

  def index
    redirect_to user_root_path if signed_in?

    @users = User.where(:skin.ne => nil).shuffle
  end

end
