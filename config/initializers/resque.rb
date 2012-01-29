module Resque
  module Logging
    def logger
      @logger ||= Rails.logger
    end
    
    def self.included(mod)
      mod.extend self
    end
  end
end

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
