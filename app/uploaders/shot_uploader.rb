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

end
