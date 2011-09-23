class HomeController < ApplicationController

  def index
    redirect_to user_root_path if signed_in?

    @usernames = User.all.map {|user| user.safe_username}.shuffle
  end

end
