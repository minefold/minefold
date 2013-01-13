require 'resque/failure/multiple'
require 'resque/failure/redis'

Resque.redis = $redis

Resque::Failure.backend = Resque::Failure::Multiple
Resque::Failure::Multiple.classes = [
  Resque::Failure::Redis,
  Resque::Failure::Bugsnag
]

Resque::Mailer.excluded_environments = [:test]
