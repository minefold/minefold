class SessionsController < Devise::SessionsController
  
  skip_before_filter :require_username!, only: [:destroy]

  def create
    super
    track 'signed in'
  end

end
