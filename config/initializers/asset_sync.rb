AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id = 'AKIAJPN5IJVEBB2QE35A'
  config.aws_secret_access_key = '4VI8OqUBN6LSDP6cAWXUo0FM1L/uURRGIGyQCxvq'
  config.fog_directory = 'minefold-production-assets'

  # Increase upload performance by configuring your region
  config.fog_region = 'us-east-1'

  # Automatically replace files with their equivalent gzip compressed version
  config.gzip_compression = true

  config.fail_silently = false
end
