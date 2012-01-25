task "resque:setup" => :environment do
  Bundler.require :worker

  require 'resque/failure/multiple'
  require 'resque/failure/redis'

  Resque::Failure::Exceptional.configure do |config|
    config.api_key = ENV['EXCEPTIONAL_API_KEY']
    config.use_ssl = true
  end

  Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Exceptional]
  Resque::Failure.backend = Resque::Failure::Multiple
end
