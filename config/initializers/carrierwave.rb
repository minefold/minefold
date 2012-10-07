class CarrierWave::Uploader::Base
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
end

CarrierWave.configure do |config|
  config.cache_dir = Rails.root.join('tmp', 'uploads')

  if Rails.env.production? or Rails.env.staging?
    config.storage = :fog

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id:  ENV['S3_KEY'],
      aws_secret_access_key: ENV['S3_SECRET'],
      region:'us-east-1'
    }

    config.fog_directory = ENV['S3_BUCKET']

    # TODO Wait for un-shit version of Carrierwave to come out
    # config.fog_host = ENV['ASSET_HOST']

    config.fog_public = true
    config.fog_attributes = {
      'Cache-Control' => "max-age=#{1.year.to_i}"
    }

  else
    config.storage = :file
    config.root = File.join(Rails.public_path, 'uploads')
    config.base_path = '/uploads'
    
  end

end
