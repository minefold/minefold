class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    existing_user = current_user || if params[:user_id]
      User.find(params[:user_id])
    end

    user = User.find_or_create_for_facebook_oauth(request.env["omniauth.auth"], existing_user, params[:email])
    user.remember_me = true

    cookies[:mpid] = user.mpid

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
    sign_in_and_redirect user, :event => :authentication
  end
end