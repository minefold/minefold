CarrierWave.configure do |config|
  
  config.cache_dir = Rails.root.join('tmp', 'uploads')

  config.fog_credentials = {
    provider: 'AWS',
    # hardcoded for "development speed"
    aws_access_key_id:  ENV['S3_KEY'] || 'AKIAJPN5IJVEBB2QE35A',
    aws_secret_access_key: ENV['S3_SECRET'] || '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',
    region:'us-east-1'
  }

  config.fog_public = true
  config.fog_attributes = {
    'Cache-Control' => "max-age=#{10.years.to_i}"
  }
end
