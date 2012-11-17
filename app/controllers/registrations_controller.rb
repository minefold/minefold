class RegistrationsController < Devise::RegistrationsController

  def new
    if params[:i] and @invited_by = User.find_by_invitation_token( params[:i])
      session[:invitation_token] = params[:i]
    end

    super
  end

  def after_sign_up_path_for(resource)
    user_root_path
  end

end
