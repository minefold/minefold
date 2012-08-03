class CoverPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :small do
    process resize_to_fill: [260, 195]
  end

  def default_url
    image_path('default_world.png')
  end

end
