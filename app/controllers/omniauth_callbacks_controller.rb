class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :html
  
  prepend_before_filter :authenticate_user!
  
  def facebook
    @user = current_user or User.find_for_facebook_oauth(request.env['omniauth.auth'])

    # Signed out, signing in
    if not signed_in? and @user and @user.facebook_linked?
      @user.update_facebook_auth(request.env['omniauth.auth'])
      @user.save
      
      sign_in_and_redirect(@user)
    
    # Signed in, linking Facebook account
    elsif signed_in? and not @user.facebook_linked?
      Reward.claim('facebook linked', @user)
      
      flash[:notice] = 'Facebook account linked.'
      redirect_to edit_user_registration_path
    
    # Signed out, signing up
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_path
      
    end
  end

end
