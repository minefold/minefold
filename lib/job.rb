class Job
  @queue = :low

  def self.perform(*args)
    job = new(*args)

    begin
      logger.info "starting #{self.name}(#{args.join(', ')})"

      if job.perform?
        job.perform!
        logger.info "finished"
      else
        logger.info "skipping"
      end
    rescue => e
      logger.warn "#{e}\n#{e.backtrace.join("\n")}"
      raise e
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
