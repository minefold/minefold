AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id = 'AKIAJPN5IJVEBB2QE35A'
  config.aws_secret_access_key = '4VI8OqUBN6LSDP6cAWXUo0FM1L/uURRGIGyQCxvq'
  config.fog_directory = 'minefold-production-assets'

  # Increase upload performance by configuring your region
  config.fog_region = 'us-east-1'

  # Don't delete files from the store
  # config.existing_remote_files = "keep"

  # Automatically replace files with their equivalent gzip compressed version
  config.gzip_compression = true

  # Use the Rails generated 'manifest.yml' file to produce the list of files to
  # upload instead of searching the assets directory.
  # config.manifest = true
end