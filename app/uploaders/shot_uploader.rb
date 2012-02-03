class ShotUploader < CarrierWave::Uploader::Base
  storage :fog

  def fog_directory
    ENV['SHOTS_BUCKET'] or 'minefold-development-shots'
  end

  def filename
    model.sha + ".png"
  end

  def store_dir
    nil
  end

  def extension_white_list
    %w(png)
  end

  # ---

  include CarrierWave::MiniMagick

  version(:full) do
    process resize_to_fit: [960, 540]
  end

  version(:half) do
    process resize_to_fit: [480, 270]
  end

  version(:quart) do
    process resize_to_fit: [240, 135]
  end

end
