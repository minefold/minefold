$redis = if ENV['REDIS_URL']
  uri = URI.parse(ENV['REDIS_URL'])
  Redis.new(
    host: uri.host,
    port: uri.port,
    password: uri.password
  )
else
  Redis.new
end

$party_cloud_redis = if ENV['PARTY_CLOUD_REDIS']
  uri = URI.parse(ENV['PARTY_CLOUD_REDIS'])
  Redis.new(
    host: uri.host,
    port: uri.port,
    password: uri.password
  )
else
  Redis.new
end
