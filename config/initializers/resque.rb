Dir[File.join(Rails.root, 'app', 'models', 'jobs', '*.rb')].each { |file| require file }

require 'resque/server'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == 'admin' && password == 'carlsmum'
end
