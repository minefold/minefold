class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  process convert: 'png'

  version :small do
    process resize_to_fill: [20, 20]
  end

  version :medium do
    process resize_to_fill: [40, 40]
  end

  version :large do
    process resize_to_fill: [60, 60]
  end
  
  version :xlarge do
    process resize_to_fill: [80, 80]
  end

  # Returns the digest path of the default image so that it can be served out from CloudFront like the other static assets.
  def default_url
    filename = if model.gender == 'female'
      'default_female.png'
    else
      'default.png'
    end
    
    path = File.join 'avatar', [version_name, filename].compact.join('_')
    image_path(path)
  end

end
