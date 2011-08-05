class WorldsController < ApplicationController

  prepend_before_filter :authenticate_user!, except: :show

  def new
    @world = World.new
  end

  def create
    @world = World.new(params[:world])
    @world.creator = current_user
    if @world.save
      redirect_to @world
    else
      render json: {errors: @world.errors}
    end
  end

  def import
    world_id = params[:world_import][:world_id]
    filename = "#{world_id}-#{params[:world_import][:filename]}"
    Resque.enqueue(Job::ImportWorld, world_id, s3_sanitize(filename))
    render nothing: true
  end

  def show
    @world = World.find_by_slug!(params[:id])
    render :action => @world.status unless @world.status.blank?
  end

  def map
    @world = World.find_by_slug! params[:id]
  end

  def activate
    current_user.world = World.find_by_slug!(params[:id])

    if current_user.save
      redirect_to current_user.world
    else
      render json: {errors: current_user.errors}
    end
  end


protected

  def s3_sanitize(filename)
    filename.gsub /[ !'"]/, '_'
  end

end
