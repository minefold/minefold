class WorldsController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, except: [:show, :map]

  expose(:world) do
     if params[:id]
       World.find_by_slug!(params[:id])
     else
       World.new(params[:world])
     end
   end

  def create
    world.creator = current_user

    if world.save
      current_user.current_world = world
      current_user.save
      flash[:new] = <<-HTML
<strong>Awesome, now you can show off what you build!</strong>

Share this page with your friends and they can start playing here too.
HTML
      redirect_to world_path(world)
    else
      render :new
    end
  end

  def show
    if params[:i]
      if signed_in?
        # if they havent claimed an invite, claim this one?
        # set world to this world?
      else
        # set cookie so when user signs up at a later stage they can claim this invite
        cookies[:invite] = params[:i]
      end
    end
    respond_with world
  end

  def edit
  end

  def update
    world.update_attributes params[:world]
    if world.save
      flash[:success] = "Settings successfully updated."
      redirect_to params['return_url'] || world_path(world)
    else
      render json: {errors: world.errors}
    end
  end

  def map
  end

  def members
  end

  def invite
  end

  def play
    raise 'Not whitelisted for world' unless world.whitelisted?(current_user)

    p "Setting user to world:#{world}"

    current_user.current_world = world
    current_user.save
    redirect_to :back
  end

end
