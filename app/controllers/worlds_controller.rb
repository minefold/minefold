class WorldsController < ApplicationController
  respond_to :html, :json

  prepend_before_filter :authenticate_user!, except: [:show]
  before_filter :set_invite_code, :only => [:show, :map]

  expose(:creator) { User.find_by_slug!(params[:user_id]) }
  expose(:world) do
     if params[:id]
       World.find_by_creator_and_slug!(creator, params[:id])
     else
       World.new(params[:world])
     end
   end

  def create
    authorize! :create, world

    world.creator = current_user

    if world.save
      current_user.current_world = world
      current_user.save

      track 'created world'
    end

    respond_with world, location: user_world_path(world.creator, world)
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

    respond_with world, location: user_world_path(world.creator, world)
  end

  def join
    authorize! :play, world

    current_user.current_world = world
    current_user.save!

    track 'joined world'

    respond_with world, location: user_world_path(world.creator, world)
  end

  def clone
    clone = world.clone!
    clone.creator = current_user

    if clone.save
      current_user.current_world = clone
      current_user.save

      track 'cloned world'
    end

    respond_with world, location: user_world_path(current_user, clone)
  end
  
  def destroy
    authorize! :destroy, world
    
    members_to_notify = world.members - [world.creator]
    members_to_notify.each do |member|
      WorldMailer.world_deleted(world.name, world.creator.username, member.id).deliver
    end
    
    world.delete!
    
    track 'deleted world'
    
    redirect_to user_root_path, flash: { info: "#{world.name} was deleted" }
  end

private

  def set_invite_code
    cookies[:invite] = params[:i] if params[:i] and not signed_in?
  end

end
