class Users::PhotosController < ApplicationController
  respond_to :html, :json

  expose(:user) { User.find_by_slug!(params[:user_id]) }
  expose(:photo) {
    user.photos.find(params[:id])
  }

  def index
  end

  def lightbox
  end

  def update
    photo.update_attributes! params[:photo]
    respond_with photo
  end

  def destroy
    photo.delete
    respond_with photo
  end

end
