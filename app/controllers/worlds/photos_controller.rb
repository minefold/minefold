class Worlds::PhotosController < ApplicationController

  expose(:world) {
    World.find_by_slug!(params[:world_id])
  }

  expose(:photo) {
    if params[:id]
      world.photos.find(params[:id])
    else
      Photo.new(params[:photo])
    end
  }

  def index
    authorize! :read, world
  end

  def new
    authorize! :operate, world
  end

  def create
    authorize! :operate, world

    photo.creator = current_user
    world.photos.push photo

    track 'uploaded photo'

    redirect_to world_photos_path(world)
  end

  def show
    authorize! :read, world
  end

end
