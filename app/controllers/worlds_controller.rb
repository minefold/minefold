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

  def show
    @world = World.find_by_slug!(params[:id])
    render :action => @world.status unless @world.status.blank?
  end

  def edit
    @world = World.find_by_slug! params[:id]
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
  
  def import
    filename = [
      params[:world][:id],
      params[:world][:filename]
    ].join('-').gsub /[ !'"]/, '_'

    Resque.enqueue(Job::ImportWorld, params[:world][:id], filename)
    render nothing: true
  end
  
  
end
