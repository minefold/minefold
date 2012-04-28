class ConfirmationsController < Devise::ConfirmationsController

  skip_before_filter :require_player_verification

  expose(:user) {
    if params[:confirmation_token]
      User.confirm_by_token(params[:confirmation_token])
    end
  }

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)

      respond_with_navigational(resource){ redirect_to user_root_path }
    else
      redirect_to user_root_path
      # respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end
