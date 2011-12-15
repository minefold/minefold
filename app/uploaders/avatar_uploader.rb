class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog
  
  def fog_directory
    ENV['USER_AVATARS_BUCKET']
  end
  
  def fog_host
    ENV['USER_AVATARS_HOST']
  end
  
  def store_dir
    model.id.to_s
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
  
  # Returns the digest path of the default image so that it can be served out from CloudFront like the other static assets.
  def default_url
    filename = [version_name, 'default.png'].compact.join('_')
    path = File.join('avatar', filename)
    
    # TODO: Fix
    "/assets/#{path}"
    
    # Rails.application.assets[path].digest_path
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
