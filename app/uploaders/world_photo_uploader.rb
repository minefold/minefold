# encoding: utf-8

class WorldPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  process :resize_to_fit => [800, 600]

  # photos page is 800 px wide
  # 10 240 10 10 10 240 10 10 10 240 10

  version :thumb do
    process :resize_to_fit => [140, 140]
  end

  version :tiny do
    process :resize_to_fit => [40, 40]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
