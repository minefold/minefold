class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.development?
    storage :file
  else
    storage :fog
  end

  def fog_directory
    "avatars-production-minefold"
  end

  def store_dir
    if Rails.env.development?
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      nil
    end
  end

  version :head do
    process :crop_head!

    version(:s60) do
      process :sample => [60, 60]
    end

    version(:s48) do
      process :sample => [48, 48]
    end

    version :s36 do
      process :sample => [36, 36]
    end

    version :s24 do
      process :sample => [24, 24]
    end

    version :s18 do
      process :sample => [18, 18]
    end

    version :s16 do
      process :sample => [16, 16]
    end
  end

  def default_url
    File.join('avatar', [version_name, 'default.png'].compact.join('_'))
  end

  def sample(width, height)
    manipulate! do |img|
      img.sample "%ix%i" % [width, height]
      img = yield(img) if block_given?
      img
    end
  end

  def crop_head!
    manipulate! do |img|
      img.crop "%ix%i+%i+%i" % [8, 8, 8, 8]
      img = yield(img) if block_given?
      img
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
