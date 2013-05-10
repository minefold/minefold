class RegistrationsController < Devise::RegistrationsController

  expose(:funpack) { Funpack.find_by_slug(params[:funpack]) if params[:funpack] }

  before_filter :find_invitation, :only => :new
  after_filter :track_signup_in_mixpanel, :only => :create

# --

  def after_sign_up_path_for(resource)
    flash[:signed_up] = true
    user_root_path(event: 'welcome') # welcome param triggers conversion tracking
  end

# --

  def find_invitation
    if session[:invitation_token]
      @invited_by = User.find_by_invitation_token(session[:invitation_token])
    end
  end

  def track_signup_in_mixpanel
    track(resource.distinct_id, '$signup', invited: resource.invited?)
  end

end
