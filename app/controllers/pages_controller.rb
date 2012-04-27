class PagesController < ApplicationController
  skip_before_filter :require_player_verification, except: [:home]

  layout 'home', only: [:home]

  def home
  end

end
