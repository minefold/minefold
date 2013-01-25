require './lib/resque/plugins/heroku'
require './lib/resque/plugins/librato'
require './lib/resque/plugins/logging'

class Job
  extend Resque::Plugins::Heroku
  extend Resque::Plugins::Librato
  extend Resque::Plugins::Logging

  class JobFailed < RuntimeError
  end

  def self.queue
    :low
  end

  def self.perform(*args)
    result = new(*args).perform
    if result
      return result
    else
      raise JobFailed.new(result)
    end
  end

end
