class Job

  def self.queue
    :low
  end

  def self.perform(*args)
    logger.tagged(name.underscore) do
      begin
        logger.info "starting [#{args.map(&:inspect).join(',')}]"
        job = new(*args)

        if job.perform?
          logger.info "performing"
          job.perform!
          logger.info "finished"
        else
          logger.info "skipping"
        end
      rescue => e
        logger.warn e.to_s
        # TODO Add extra Exceptional context here.
        raise e
      end
    end
  end

  def perform?
    true
  end

  def perform!
    raise "must be overridden"
  end

# private

  def self.logger
    @logger ||= Rails.logger
  end

  def logger
    self.class.logger
  end

end
