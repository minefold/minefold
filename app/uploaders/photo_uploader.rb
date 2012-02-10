class PhotoUploader < CarrierWave::Uploader::Base
  if Rails.env.production? or Rails.env.staging?
    storage :fog

    def fog_directory; ENV['PHOTOS_BUCKET']; end
    def fog_host; ENV['PHOTOS_CF_HOST']; end
    def store_dir; nil; end

  else
    storage :file
  end

  def filename
    "#{model.sha}.png"
  end

  def extension_white_list
    %w(png)
  end


  include CarrierWave::MiniMagick

  version(:full) do
    process resize_to_fit: [960, 720]
  end

  version(:large) do
    process resize_to_fit: [700, 525]
  end

  version(:lightbox) do
    process resize_to_fit: [460, 345]
  end

  version(:small) do
    process resize_to_fill: [140, 140]
  end

end
