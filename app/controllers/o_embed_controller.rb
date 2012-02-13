class OEmbedController < ApplicationController

  respond_to :json, :xml

  def show
    url = Addressable::URI.parse(params[:url])
    recognized_params = Rails.application.routes.recognize_path(url.path, method: :get)

    # Kick unless we are showing a resouce
    raise(NotFound) unless recognized_params[:action] == 'show'

    @obj = case recognized_params[:controller]
      when 'photos'
        Photo.find(recognized_params[:id])
      else
        raise(NotFound)
      end || raise(Mongoid::Errors::DocumentNotFound)

    respond_with(@obj)
  end

end
