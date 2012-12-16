class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :html

  prepend_before_filter :authenticate_user!

  # Facebook User
  expose(:user) {
    User.find_for_facebook_oauth(auth, current_user)
  }

  def facebook
    # Signed out, signing in
    if !signed_in? && user
      user.update_from_facebook_auth(auth)
      user.save

      sign_in_and_redirect(user)

    # Signed in, linked a previously linked Facebook account
    elsif signed_in? && user
      flash[:error] = 'Facebook account already linked.'
      redirect_to edit_user_registration_path

    # Signed in, linking Facebook account
    elsif signed_in?
      current_user.accounts << Accounts::Facebook.new(uid: auth.uid)
      current_user.update_from_facebook_auth(auth)

      Bonuses::LinkedFacebookAccount.claim!(current_user)

      current_user.save

      flash[:notice] = 'Facebook account linked.'
      redirect_to edit_user_registration_path

    # Signed out, signing up
    else
      session['devise.facebook_data'] = auth
      redirect_to new_user_registration_path

    end
  end

private

  def auth
    request.env['omniauth.auth']
  end

end
