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
      User.first(conditions: {referral_code: cookies[:invite]})
    end
  }

  def show
    respond_to do |format|
      format.html
      format.json { render json: user.as_json(only: [:username, :id]) }
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
      respond_with user, :location => new_world_path
    else
      clean_up_passwords user
      respond_with user, :location => users_path(code: params[:user][:invite_id])
    end
  end

  def edit
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to user_root_path
  end

end
