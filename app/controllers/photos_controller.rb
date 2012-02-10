class PhotosController < ApplicationController
  respond_to :html

  expose(:photos) { Photo.public }
  expose(:photo)

  def index
    respond_with photos
  end

  def show
    respond_with(photo) do |format|
      format.html {
        photo.inc :pageviews, 1
      }
    end
  end

  def lightroom
  end

end
