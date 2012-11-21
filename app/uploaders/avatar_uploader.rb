class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process convert: 'png'

  version :small do
    process resize_to_fill: [24, 24]
  end

  version :medium do
    process resize_to_fill: [60, 60]
  end

  version :large do
    process resize_to_fill: [140, 140]
  end

  # Returns the digest path of the default image so that it can be served out from CloudFront like the other static assets.
  def default_url
    base = ['default', model.gender, version_name].compact.join('_')
    filename = "#{base}.png"
    image_path File.join('avatars', filename)
  end

end
