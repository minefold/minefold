require './lib/resque/plugins/flush_analytics'
require './lib/resque/plugins/heroku'
require './lib/resque/plugins/librato'
require './lib/resque/plugins/logging'

class Job
  extend Resque::Plugins::FlushAnalytics
  extend Resque::Plugins::Heroku
  extend Resque::Plugins::Librato
  extend Resque::Plugins::Logging

  def self.queue
    :low
  end

  def self.perform(*args)
    new(*args).perform
  end

end
