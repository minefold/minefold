class WorldsController < ApplicationController

  prepend_before_filter :authenticate_user!, except: :show

  def new
    @world = World.new
  end

  def create
    world = World.new params[:world]
    world.admins << current_user
    world.save!

    redirect_to "/#{world.slug}"
  end

  def show
    @world = World.find_by_slug! params[:id]

    render :action => @world.status unless @world.status.blank?
  end

  def activate
    @world = World.first :slug => params[:id]

    current_user.set world_id: @world.id

    redirect_to @world
  end

  def chat
    world = World.first :slug => params[:id]

    comment = Chat.new(user: current_user, body: params[:body], wall: world)

    if comment.valid? and comment.save
      redirect_to world
    else
      render json: {errors: comment.errors}, status: :bad_request
    end
  end

end
