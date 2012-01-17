class WorldsController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, except: [:show, :map]
  before_filter :set_invite_code, :only => [:show, :map]

  expose(:world) do
     if params[:id]
       World.find_by_slug!(params[:id])
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

    world.inc :pageviews, 1

    respond_with world
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

  def map
    authorize! :read, world
  end

  def play
    authorize! :update, world

    current_user.current_world = world
    current_user.save

    track 'changed worlds'

    redirect_to :back
  end

private

  def set_invite_code
    # THINK: Should we retroactively apply invite codes?
    cookies[:invite] = params[:i] if params[:i] and not signed_in?
  end

end
