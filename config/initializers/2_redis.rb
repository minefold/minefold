uri = URI.parse(ENV["REDIS_URI"] || 'redis://localhost:6379')
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
