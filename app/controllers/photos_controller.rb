class PhotosController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, only: [:lightroom]

  expose(:photos) { Photo.published }
  expose(:photo)

  def index
    if signed_in?
      render action: 'lightroom'
    else
      render action: 'index'
    end
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

  def update_lightroom
    current_user.photos_attributes = params[:user][:pending_photos_attributes]
    redirect_to photos_path
  end

end
