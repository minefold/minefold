class OEmbedController < ApplicationController

  def show
    url = Addressable::URI.parse(params[:url])
    recognized_params = Rails.application.routes.recognize_path(url.path, method: :get)

    # Kick unless we are showing a resouce
    unless recognized_params[:action] == 'show'
      render(:text => '', :status => :not_found)
      return
    end

    case recognized_params[:controller]
    when 'photos'
      photo = Photo.find(recognized_params[:id]) || raise(Mongoid::Errors::DocumentNotFound)

      render :text => {
        :type => 'photo',
        :version => '1.0',
        :title => photo.title,
        :author_name => photo.creator.username,
        :author_url => user_url(photo.creator),
        :provider_name => 'Minefold',
        :provider_url => root_url,
        :thumbnail_url => photo.file.small.url,
        # photo specific urls
        :url => photo.file.full.url,
        :width => photo.width,
        :height => photo.height
      }.to_json
    else
      render(:status => :not_found)
    end
  end

end
