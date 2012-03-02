class SessionsController < Devise::SessionsController

  def create
    cookies[:mpid] = current_user.mpid
    super
    track 'signed in', distinct_id: current_user.id.to_s,
                       mp_name_tag: current_user.safe_username
  end

end
