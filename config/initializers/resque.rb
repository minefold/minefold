# require File.join(Rails.root, 'app', 'models', 'jobs', 'base')
Dir[File.join(Rails.root, 'app', 'models', 'jobs', '*.rb')].each { |file| require file }

require 'resque/server'

unless ENV["REDISTOGO_URL"].blank?
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

# Resque::Server.use Rack::Auth::Basic do |username, password|
#   # NOTE: This is just an authentication for localhost:3000/resque
#   username == "minefold"
#   password == ENV["RESQUE_PASSWORD"] || "carlsmum"  # The later is for development mode.
# end