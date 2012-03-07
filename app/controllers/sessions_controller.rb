class SessionsController < Devise::SessionsController
  
  skip_before_filter :require_username!, only: [:destroy]

  def create
    super
    track 'signed in', distinct_id: current_user.id.to_s,
                       mp_name_tag: current_user.safe_username
  end

end
