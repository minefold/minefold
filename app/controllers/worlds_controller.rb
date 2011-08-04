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

  def activate
    current_user.world = World.find_by_slug!(params[:id])
    redirect_to current_user.world
  end

end
