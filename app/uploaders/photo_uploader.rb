class PhotoUploader < CarrierWave::Uploader::Base

  if Rails.env.production? or Rails.env.staging?
    storage :fog

    def fog_directory; ENV['PHOTOS_BUCKET']; end
    def fog_host; ENV['PHOTOS_HOST']; end
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

  process :set_sha

  version(:full) do
    process resize_to_fit: [960, 720]
    process set_geometry: [:width, :height]
  end

  version(:large) do
    process resize_to_fit: [700, 525]
  end

  version(:medium) do
    process resize_to_fit: [460, 345]
  end

  version(:small) do
    process resize_to_fill: [140, 140]
  end

  version(:thumb) do
    process resize_to_fit: [70, 70]
    process set_geometry: [:thumb_width, :thumb_height]
  end

  def set_geometry(width_attr, height_attr)
    image = MiniMagick::Image.open(current_path)
    model[width_attr] = image[:width]
    model[height_attr] = image[:height]
  end

  def set_sha
    model.sha = Digest::SHA1.hexdigest(read)
  end

end
