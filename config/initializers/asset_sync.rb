AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id = ENV['S3_KEY']
  config.aws_secret_access_key = ENV['S3_SECRET']
  config.fog_directory = 'minefold-production-assets'

  # Increase upload performance by configuring your region
  config.fog_region = 'us-east-1'

  # Automatically replace files with their equivalent gzip compressed version
  config.gzip_compression = true
end
