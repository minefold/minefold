class UsersController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [:new, :create]
  prepend_before_filter :authenticate_user!, :only => [:dashboard, :edit, :update]

  respond_to :html, :json

  expose(:user) {
    if params[:user_id] || params[:id]
      User.find_by_slug!(params[:user_id] || params[:id])
    else
      User.new params[:user]
    end
  }

  expose(:referrer) {
    if cookies[:invite]
      User.where(referral_code: cookies[:invite]).first
    end
  }

  def new
    render session["devise.facebook_data"] ? 'new_facebook' : 'new'
  end

  def create
    user.mpid = cookies[:mpid]
    user.referrer = referrer

    if user.save
      sign_in :user, user

      track '$signup', distinct_id: user.mpid, mp_name_tag: user.safe_username

      respond_with user, :location => user_root_path
    else
      clean_up_passwords user
      respond_with user do |format|
        format.html { render session["devise.facebook_data"] ? 'new_facebook' : 'new' }
      end
    end
  end

  def show
    authorize! :read, user

    respond_with(user) do |format|
      format.png {
        redirect_to user.avatar_url(50)
      }
    end
  end


end
