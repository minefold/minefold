class UsersController < ApplicationController
  include Devise::Controllers::InternalHelpers

  prepend_before_filter :require_no_authentication, :only => [:new, :create]
  prepend_before_filter :authenticate_user!, :only => [:dashboard, :edit, :update]

  before_filter :check_spots_left, :only => [:new, :create]

  expose(:user)

  def show
    @user = User.find_by_slug!(params[:id])
  end

  def dashboard
    @worlds = World.order_by([:slug, :asc]).all

    @current_world = current_user.current_world
    @current_world_players_count = @current_world.connected_players_count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in :user, @user
      respond_with @user, :location => stored_location_for(:user) || user_root_path
    else
      clean_up_passwords(@user)
      respond_with @user, :location => users_path
    end
  end

  def edit
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to user_root_path
  end

  def search
    @results = User.where(username: /#{params[:q]}/i).limit(5).all
    render json: @results.map {|u|
      {id: u.id, username: u.username}
    }
  end

protected

  def check_spots_left
    not_found if !User.free_spots? and params[:secret] != 'fe0e675728078c78912cd5a9779f0217e3c90f6ec9bc9d89240cf4236145a7429e257a8c7dcae8f0267944bbc1ca9adb5519706e01d3d9aadcc46b727df34567'
  end

end
