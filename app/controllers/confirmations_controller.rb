class ConfirmationsController < Devise::ConfirmationsController

  expose(:user) {
    if params[:confirmation_token]
      User.confirm_by_token(params[:confirmation_token])
    end
  }

  def show
    if user and user.valid?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in :user, user

      UserMailer.welcome(user.id).deliver

      respond_with_navigational(user){ redirect_to after_confirmation_path_for(:user, user) }
    else
      respond_with_navigational(user.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end
