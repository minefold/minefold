task "resque:setup" => :environment do
  Bundler.require :worker
  
  p Rails.env.production?
  
  require 'resque/failure/multiple'
  require 'resque/failure/airbrake'
  require 'resque/failure/redis'
  Resque::Failure::Airbrake.configure do |config|
    config.api_key = '2a986c2b8d31075b30f812baeabb97f7'
    config.secure = true
  end
  Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
  Resque::Failure.backend = Resque::Failure::Multiple
end
