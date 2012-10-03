class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = if signed_in?
      current_user
    else
      User.find_or_initialize_from_facebook(request.env['omniauth.auth'])
    end

    user.remember_me = true

    # TODO Unstub path
    if user.new_record?
      session['user_return_to'] = onboard_users_path
    end

    sign_in_and_redirect user, :event => :authentication
  end

end
