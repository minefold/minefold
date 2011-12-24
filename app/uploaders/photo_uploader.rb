class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog
  
  def fog_directory
    ENV['PHOTOS_BUCKET']
  end
  
  
  def fog_host
    ENV['PHOTOS_HOST']
  end if ENV['PHOTOS_HOST']
  
  def store_dir
    File.join(model.world.id.to_s, model.id.to_s)
  end
  
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  version(:thumb) do
    process resize_to_fill: [120, 120]
  end
  
  version(:large) do
    # 4:3 aspect ratio. Also covers 16:9 which is what most wide-screen monitors are these days.
    process resize_to_fit: [800, 600]
  end
  
end
