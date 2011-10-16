class WorldsController < ApplicationController
  # prepend_before_filter :authenticate_user!, except: [:show, :map]

  # expose(:creator) { User.find_by_slug!(params[:user_id])}
  # expose(:world) do
  #   if creator
  #     creator.created_worlds.find_by_slug!(params[:id])
  #   else
  #     World.new(params[:world])
  #   end
  # end

  respond_to :html


  def new
    world.creator = current_user
  end

  def create
    @world = World.new(params[:world])
    @world.creator = current_user

    if @world.save
      current_user.current_world = @world
      current_user.save
      flash[:new] = true
      redirect_to user_world_path(@world.creator, @world)
    else
      render :new
    end
  end

  def show
    @creator = User.find_by_slug! params[:user_id]
    @world = @creator.created_worlds.find_by_slug! params[:id]

    respond_with @world
  end

  def edit
  end

  def update
    world.update_attributes params[:world]
    if world.save
      flash[:success] = "Settings successfully updated."
      redirect_to params['return_url'] || user_world_path(world.creator, world)
    else
      render json: {errors: world.errors}
    end
  end

  def map
  end

  def members
  end

  def invite
    @invite = Invite.new(world: world, from: current_user)
  end

  def play
    if world.whitelisted?(current_user)
      current_user.current_world = world
      current_user.save
    end
    redirect_to :back
  end

  # def play_request
  #   @invite = world.invites.create from: current_user, to: world.owner
  #
  #   # WorldMailer.play_request(world.id,
  #   #                          world.owner.id,
  #   #                          current_user.id).deliver
  #   redirect_to user_world_path(world.owner, world)
  # end
end
