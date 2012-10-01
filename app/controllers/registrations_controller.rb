class RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    onboard_users_path
  end
  
end
