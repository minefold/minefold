class PagesController < ApplicationController

  skip_before_filter :require_player_verification

  layout 'home', :only => :home

  def home
    redirect_to(user_root_path) if signed_in?
  end

end
