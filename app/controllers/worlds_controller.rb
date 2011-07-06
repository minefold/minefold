class WorldsController < ApplicationController
  respond_to :html
  
  expose(:world) { 
    if params[:slug]
      World.find_by_slug!(params[:slug])
    else 
      World.new
    end
  }
  
  def create
    world = World.new params[:world]
    world.admins << current_user
    world.players << current_user
    world.save!
    
    redirect_to "/#{world.slug}"
  end

  def activate
    @world = World.first :slug => params[:id]

    current_user.active_world = @world
    current_user.save
    redirect_to :back
  end
end
