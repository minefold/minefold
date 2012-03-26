class SessionsController < Devise::SessionsController

  skip_before_filter :require_username!, only: [:destroy]
  skip_before_filter :require_player_verification, :only => [:destroy]
  
  layout 'system', only: [:new]

  def create
    super
    track 'signed in'
  end

end
