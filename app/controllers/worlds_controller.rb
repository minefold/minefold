class WorldsController < ApplicationController
  respond_to :html, :json

  prepend_before_filter :authenticate_user!, except: [:show, :map]
  before_filter :set_invite_code, :only => [:show, :map]

  expose(:creator) { User.find_by_slug! params[:user_id] }

  expose(:world) do
     if params[:id]
       World.find_by_slug!(creator.id, params[:id])
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

      redirect_to world_path(world)
    else
      render :new
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

    world.update_attributes params[:world]
    if world.save
      flash[:success] = "World updated"
      redirect_to params['return_url'] || world_path(world)
    else
      render json: {errors: world.errors}
    end
  end

  def play
    authorize! :play, world

    current_user.current_world = world
    current_user.save

    track 'changed worlds'

    redirect_to :back
  end
  
  def clone
    cloned_world = world.clone_world(current_user)
    cloned_world.save!
    
    current_user.current_world = cloned_world
    current_user.save!
    
    redirect_to user_world_path(current_user, cloned_world)
  end

private

  def set_invite_code
    # THINK: Should we retroactively apply invite codes?
    cookies[:invite] = params[:i] if params[:i] and not signed_in?
  end

end
