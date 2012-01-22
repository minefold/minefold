class Worlds::PicturesController < ApplicationController

  respond_to :html, :json

  expose(:creator) { User.find_by_slug! params[:user_id] }
  expose(:world) {
    World.find_by_slug!(creator.id, params[:world_id])
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

    respond_with world.photos.to_a
  end

  def new
    authorize! :operate, world
  end

  def create
    authorize! :operate, world

    photo.creator = current_user
    world.photos.push photo

    track 'uploaded picture'

    redirect_to world_photos_path(world)
  end

  def show
    authorize! :read, world
  end

end
