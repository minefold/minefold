class RegistrationsController < Devise::RegistrationsController
  
  def new
    # TODO Move this hack into User.new_with_session(hash, session)
    if mixpanel_cookie.present?
      @distinct_id = JSON.parse(mixpanel_cookie)['distinct_id']
    end
    
    super
  end
  
  def after_sign_up_path_for(resource)
    onboard_users_path
  end

# --

  def mixpanel_cookie
    request.cookies['mp_mixpanel']
  end

end
