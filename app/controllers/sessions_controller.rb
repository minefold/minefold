class SessionsController < Devise::SessionsController

  skip_before_filter :require_player_verification, only: [:destroy]

end
