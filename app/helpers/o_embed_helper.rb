module OEmbedHelper

  def photo_oembed_url(photo)
    oembed_photos_url(url: CGI.escape(photo_url(photo)))
  end

end
