class Worlds::PhotoSetsController < ApplicationController
  
  expose(:world) {
    World.find_by_slug!(params[:world_id])
  }
  
  def new
    @photo_set = world.photo_sets.new
  end
  
  def create
    world.photo_sets.build(params[:photo_set])
    world.save
    
    redirect_to world_path(world)
  end
  
end
