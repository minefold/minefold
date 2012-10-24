require 'resque/failure/multiple'
require 'resque/failure/redis'
require 'resque/scheduler'

Resque::Failure::Multiple.classes = [
    Resque::Failure::Redis,
    Resque::Failure::Bugsnag
  ]

Resque::Failure.backend = Resque::Failure::Multiple

Resque.redis = $redis

Resque::Mailer.excluded_environments = [:test]
