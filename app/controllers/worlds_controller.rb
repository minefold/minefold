class WorldsController < ApplicationController

  def create
    @world = World.create_by current_user, params[:world]

    # if @world.valid? and @world.save

    @world.admins << current_user
    @world.players << current_user

    redirect_to root_path
  end

  def activate
    @world = World.first :slug => params[:id]

    current_user.active_world = @world
    current_user.save
    redirect_to :back
  end
end
