class Job
  extend Resque::Plugins::Heroku

  def self.queue
    :low
  end

  def self.perform(*args)
    logger.tagged(name.underscore) do
      begin
        logger.info "starting with #{args.inspect}"
        job = new(*args)

        if job.perform?
          logger.info "performing"
          job.perform!
          logger.info "finished"
          Librato::Rails.flush
        else
          logger.info "skipping"
        end
      rescue => e
        logger.warn e.to_s
        raise e
      end
    end
  end

  def perform?
    true
  end

  def perform!
  end

# private

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Rails.logger
  end

  def logger
    self.class.logger
  end
end
