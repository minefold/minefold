class CoverPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def fog_host
    ENV['AVATARS_HOST']
  end

  version :small do
    process resize_to_fill: [220, 140]
  end

end
