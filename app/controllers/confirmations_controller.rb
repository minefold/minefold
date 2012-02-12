class ConfirmationsController < Devise::ConfirmationsController

  expose(:user) {
    if params[:confirmation_token]
      User.confirm_by_token(params[:confirmation_token])
    end
  }

  def show
    self.resouce = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)

      UserMailer.welcome(resource.id).deliver

      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end
