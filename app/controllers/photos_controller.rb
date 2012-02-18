class PhotosController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, only: [:lightroom]

  expose(:photos) { Photo.published }
  expose(:photo)

  def index
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
    params[:user][:pending_photos_attributes].each do |_, attrs|
      update_set = {
        'title' => attrs["title"],
        "desc" =>  attrs["desc"]
      }

      if not attrs['published'].blank?
        update_set['published'] = (attrs['published'] == 'true')
      end

      Photo.collection.update(
        {'_id' => BSON::ObjectId(attrs['id'])},
        {'$set' => update_set}
      )
    end

    redirect_to lightroom_photos_path
  end

  def download
    track 'downloaded client', os: 'mac', version: '1.04'

    redirect_to 'http://minefold-macclient.s3.amazonaws.com/Minefold%201.04.zip'
  end

end
