require 'resque/failure/multiple'
require 'resque/failure/redis'

Resque::Failure::Multiple.classes = [
    Resque::Failure::Redis,
    Resque::Failure::Bugsnag
  ]

Resque::Failure.backend = Resque::Failure::Multiple

Resque.redis = $redis
