class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(png)
  end

  process :crop_head!

  version :small do
    process :sample => [20, 20]
  end

  version :medium do
    process :sample => [40, 40]
  end

  version :large do
    process :sample => [60, 60]
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
end
