CarrierWave.configure do |config|
  config.storage = :fog

  config.store_dir = if Rails.env.development?
    'public/uploads'
  else
    nil
  end

  config.fog_credentials = if Rails.env.development?
    {
      provider: :local,
      local_root: Rails.root.join('public','uploads')
    }
  else
    {
      provider:'AWS',
      aws_access_key_id:ENV['S3_KEY'],
      aws_secret_access_key:ENV['S3_SECRET'],
      region:'us-east-1'
    }
  end

  config.fog_public = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end