class ShotUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process convert: 'jpg'

  version :stream do
    process resize_to_fill: [660, 495]
  end

end
