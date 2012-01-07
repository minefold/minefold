class Api::PhotosController < Api::ApiController
  expose(:world) { current_user.current_world }
  
  def create
    photo = world.photos.create params[:photo]
    photo.creator = current_user
    
    track 'uploaded photo', source: 'windows client'
    
    render status: 200, layout: false, nothing: true
  end
end