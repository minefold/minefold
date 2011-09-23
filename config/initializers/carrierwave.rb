CarrierWave.configure do |config|
  if Rails.env.development?
    config.fog_credentials = {
      :provider      => :local,
      :local_root    => "#{Rails.root}/tmp/local_storage"
    }
  else
    config.storage = :s3
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET']
    }
    config.fog_directory  = "minefold.#{Rails.env}.worlds.photos"
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end