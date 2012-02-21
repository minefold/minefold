class CoverPhotoUploader < CarrierWave::Uploader::Base

  if Rails.env.production? or Rails.env.staging?
    storage :fog

    def fog_directory
      ENV['COVER_PHOTOS_BUCKET']
    end

    def fog_host
      ENV['COVER_PHOTOS_HOST']
    end

  else
    storage :file
  end

  def store_dir
    File.join(model.class.name.downcase, model.id.to_s)
  end


# ---


  include CarrierWave::MiniMagick

  version :small do
    process resize_to_fill: [140, 140]
  end

end
