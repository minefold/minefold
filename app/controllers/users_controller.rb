class UsersController < Devise::RegistrationsController
  respond_to :html, :json

  prepend_before_filter :require_no_authentication, only: [:new, :create]
  prepend_before_filter :authenticate_scope!, only: [:onboard, :update]

# --

  expose(:user)

# --

  def show
    respond_with(user)
  end

  def edit
  end

  def update
    authorize! :update, user
    user.save
    respond_with(user, location: edit_user_registration_path)
  end

end
