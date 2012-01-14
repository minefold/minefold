class UsersController < ApplicationController
  include Devise::Controllers::InternalHelpers

  prepend_before_filter :require_no_authentication, :only => [:new, :create]
  prepend_before_filter :authenticate_user!, :only => [:dashboard, :edit, :update]

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

  respond_to :html, :json

  def show
    authorize! :read, user

    respond_with(user) do |format|
      format.png {
        redirect_to user.avatar_url(50)
      }
    end
  end

  def new
  end

  def check
    render json: {
      username: params[:username],
      paid: User.paid_for_minecraft?(params[:username])
    }
  end

  def create
    user.referrer = referrer
    if user.save
      UserMailer.welcome(user.id).deliver

      sign_in :user, user

      track '$signup', distinct_id: user.id.to_s, mp_name_tag: user.safe_username

      respond_with user, :location => new_world_path
    else
      clean_up_passwords user
      respond_with user, :location => users_path(code: params[:user][:invite_id])
    end
  end

end
