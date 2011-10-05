CarrierWave.configure do |config|
  config.cache_dir = Rails.root.join('tmp', 'uploads')

  config.fog_credentials = {
    provider:'AWS',
    aws_access_key_id:ENV['S3_KEY'],
    aws_secret_access_key:ENV['S3_SECRET'],
    region:'us-east-1'
  }

  config.fog_public = true
  config.fog_host   = 'https://avatars-production-minefold.minefold.com'
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end
