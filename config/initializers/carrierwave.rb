CarrierWave.configure do |config|
  if Rails.env.production? or Rails.env.staging?
    config.storage = :fog

    config.root = Rails.root.join('tmp')
    config.cache_dir = Rails.root.join('tmp', 'uploads')

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id:  ENV['S3_KEY'],
      aws_secret_access_key: ENV['S3_SECRET'],
      region:'us-east-1'
    }

    config.fog_directory = ENV['ASSETS_BUCKET']
    config.fog_host = ENV['ASSET_HOST']

    config.fog_public = true
    config.fog_attributes = {
      'Cache-Control' => "max-age=#{1.day.to_i}"
    }

  else
    config.storage = :file

    config.root = Rails.root.join('public', 'uploads')
    config.cache_dir = Rails.root.join('tmp', 'uploads')
    config.base_path = '/uploads'
  end

end
