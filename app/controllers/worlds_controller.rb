class WorldsController < ApplicationController

  def show
    @world = World.first :name => params[:name]
    raise MongoMapper::DocumentNotFound unless @world
  end

  def new
    @world = World.new
  end

  def create
    @world = World.create! params[:world]
    @world.admins << current_user
    @world.players << current_user
    @world.save

    redirect_to root_path
  end

  def activate
    @world = World.first :slug => params[:id]
    current_user.active_world = @world
    current_user.save
    redirect_to :back
  end

end
