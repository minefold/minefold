class RegistrationsController < Devise::RegistrationsController

  expose(:funpack) do
    if params[:funpack]
      Funpack.find_by_slug(params[:funpack])
    end
  end

  before_filter :find_invitation, :only => :new
  after_filter :track_signup, :only => :create

# --

  def after_sign_up_path_for(user)
    new_server_path(
      event: 'welcome',
      funpack: funpack && funpack.slug
    )
  end

# --

  def find_invitation
    if session[:invitation_token]
      @invited_by = User.find_by_invitation_token(session[:invitation_token])
    end
  end

  def track_signup
    Analytics.track(
      user_id: resource.id,
      event: '$signup',
      properties: {
        invited: resource.invited?
      }
    )

    # Writes out analytics.identify
    flash[:signed_up] = true
  end

end
