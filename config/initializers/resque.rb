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

schedule_path = Rails.root.join('config', 'scheduler.yml')
Resque.schedule = YAML.load_file(schedule_path)
