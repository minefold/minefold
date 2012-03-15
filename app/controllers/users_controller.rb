class UsersController < Devise::RegistrationsController
  respond_to :html

  prepend_before_filter :require_no_authentication, :only => [:new, :create]
  prepend_before_filter :authenticate_user!, :only => [:dashboard, :edit, :update]


# ---


  expose(:user) {
    if signed_in?
      current_user
    else
      User.new(params[:user])
    end
  }

  expose(:referrer) {
    if cookies[:invite_code]
      User.where(invite_code: cookies[:invite_code]).first
    end
  }


# ---


  def new
  end

  def create
    user.mpid = cookies[:mpid]
    user.referrer = referrer

    if user.save
      sign_in :user, user

      track '$signup', distinct_id: user.mpid.to_s, mp_name_tag: user.email

      respond_with(user, location: user_root_path)
    else
      clean_up_passwords(user)
      respond_with(user)
    end
  end

  def dashboard
  end

  def edit
  end

  def update
    authorize! :update, user

    user.update_attributes(params[:user])

    if user.save
      flash[:success] = 'Your settings were changed'
    end

    respond_with(current_user, location: account_path)
  end

end
