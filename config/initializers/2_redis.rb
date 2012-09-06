if ENV['REDIS_URI']
  uri = URI.parse(ENV["REDIS_URI"])
  $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end
