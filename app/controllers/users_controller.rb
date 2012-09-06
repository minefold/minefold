class UsersController < Devise::RegistrationsController
  respond_to :html

  prepend_before_filter :require_no_authentication, only: [:new, :create]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :verify, :pro]

# --

  expose(:user)

# --

  def new
  end

  def show
  end

  def update
    authorize! :update, user

    respond_to do |format|
      if user.update_attributes(params[:user])
        format.html { redirect_to user_root_path, notice: 'Updated settings' }
      else
        format.html { render controller: 'devise::registrations', action: 'edit' }
      end
    end

  end

  # def unlink_player
  #   authorize! :update, user
  #
  #   user.minecraft_player = nil
  #
  #   user.save!
  #
  #   respond_with(current_user, location: edit_user_path)
  # end

  # def verify
  #   redirect_to(user_root_path) if current_user.verified?
  # end

end
