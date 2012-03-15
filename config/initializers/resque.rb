if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  $redis = Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
