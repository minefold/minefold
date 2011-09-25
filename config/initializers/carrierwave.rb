CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'uploads'

  # if Rails.env.development?
  #   config.fog_credentials = {
  #     :provider      => :local,
  #     :local_root    => "#{Rails.root}/tmp/local_storage"
  #   }
  # else
  config.storage = :fog
  
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['S3_KEY'],
    :aws_secret_access_key  => ENV['S3_SECRET'],
    :region => 'us-east-1'
  }
  
  # config.fog_directory  = "minefold.#{Rails.env}.worlds.photos"
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  # end
end