Dir[File.join(Rails.root, 'app', 'models', 'jobs', '*.rb')].each { |file| require file }

require 'resque/server'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

# Resque::Server.use Rack::Auth::Basic do |username, password|
#   # NOTE: This is just an authentication for localhost:3000/resque
#   username == "minefold"
#   password == ENV["RESQUE_PASSWORD"] || "carlsmum"  # The later is for development mode.
# end