class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :html
  
  prepend_before_filter :authenticate_user!
  
  def facebook
    raw_facebook_attrs = request.env['omniauth.auth'].extra.raw_info
    
    current_user.facebook_uid = request.env['omniauth.auth'].uid
    current_user.update_facebook_attributes(raw_facebook_attrs)
    current_user.save
    
    # TODO Add credits for linking Facebook
    
    flash[:notice] = 'Facebook account linked.'
    redirect_to edit_user_registration_path
  end

end
