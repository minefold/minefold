# encoding: utf-8

class WorldPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  process :resize_to_fit => [800, 600]

  # photos page is 800 px wide
  # 10 240 10 10 10 240 10 10 10 240 10
  
  version :small do
    process :resize_to_fit => [240, 180]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
