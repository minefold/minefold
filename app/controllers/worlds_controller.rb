class WorldsController < ApplicationController
  respond_to :html, :json

  prepend_before_filter :authenticate_user!, except: [:index, :show]
  before_filter :set_invite_code, :only => [:show, :map]


# ---


  expose(:player) {
    MinecraftPlayer.find_by_username(params[:player_id])
  }

  expose(:user) {
    player.user
  }

  expose(:world) do
    if params[:id]
      user.created_worlds.find_by_name(params[:id])
    else
      World.new(params[:world])
    end
  end


# ---


  def index
    @worlds = World.where(:photo.ne => nil)
      .page(params[:page].to_i)
      .order_by([:pageviews, :desc])
  end

  def new
    authorize! :create, world
  end

  def create
    authorize! :create, world

    world.creator = current_user

    if world.save
      current_user.current_world = world
      current_user.save

      track 'created world'
    end

    respond_with world do |format|
      format.html {
        redirect_to player_world_path(current_user.minecraft_player, world)
      }
    end
  end

  def show
    authorize! :read, world

    respond_with(world) do |format|
      format.html {
        world.inc :pageviews, 1
      }
    end
  end

  def edit
    authorize! :update, world
  end

  def update
    authorize! :update, world

    world.update_attributes(params[:world])

    respond_with world, location: player_world_path(player, world)
  end

  def clone
    clone = world.clone!
    clone.creator = current_user

    clone.save!

    current_user.current_world = clone
    current_user.save

    track 'cloned world'

    respond_with clone, location: player_world_path(current_user.minecraft_player, clone)
  end

  def destroy
    authorize! :destroy, world

    members_to_notify = world.players - [world.creator.minecraft_player]
    members_to_notify.select{|p| p.user }.each do |player|
      WorldMailer.world_deleted(world.name, world.creator.minecraft_player.username, player.user.id).deliver
    end

    world.delete

    track 'deleted world'

    redirect_to user_root_path, flash: { info: "#{world.name} was deleted" }
  end

private

  def set_invite_code
    cookies[:invite] = params[:i] if params[:i] and not signed_in?
  end

end
