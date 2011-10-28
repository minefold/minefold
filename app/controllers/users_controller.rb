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

  def show
    respond_to do |format|
      format.html
      format.json { render json: user.as_json(only: [:username, :id]) }
    end
  end

  def new
    if invite = Invite.where(claimed: false, code: params[:code]).first
      user.invite = invite
    end
  end

  def check
    render json: {
      username: params[:username],
      paid: User.paid_for_minecraft?(params[:username])
    }
  end

  def create
    if user.save
      if params[:user][:invite_id]
        user.invite = Invite.find params[:user][:invite_id]
      elsif cookies[:invite]
        user.invite = Invite.find_by_code cookies[:invite]
      end

      if user.invite
        user.invite.world.whitelisted_players << user
        user.invite.world.save

        user.current_world = user.invite.world
        user.save

        user.invite.claimed = true
        user.invite.save
      end

      UserMailer.welcome(user.id).deliver
      sign_in :user, user
      respond_with user, :location => new_world_path
    else
      clean_up_passwords(@user)
      respond_with user, :location => users_path(code: params[:user][:invite_id])
    end
  end

  def edit
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to user_root_path
  end

  # def upgrade
  #   if user.save
  # end

  # def search
  #   @results = User.where(username: /#{params[:q]}/i).limit(5).all
  #   render json: @results.map {|u|
  #     {id: u.id, username: u.username}
  #   }
  # end

protected

  # def check_spots_left
  #   not_found if !User.free_spots? and params[:secret] != 'fe0e675728078c78912cd5a9779f0217e3c90f6ec9bc9d89240cf4236145a7429e257a8c7dcae8f0267944bbc1ca9adb5519706e01d3d9aadcc46b727df34567'
  # end

end
