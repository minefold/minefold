class Job
  @queue = :low

  def self.perform(*args)
    job = new(*args)

    return unless job.perform?

    begin
      logger.info "started"
      job.perform!
      logger.info "finished"
    rescue => e
      logger.warn e
      raise e
    end
  end

  def perform?
    true
  end

  def perform!
  end

# private

  def self.logger
    @logger ||= Rails.logger
  end

  def logger
    self.class.logger
  end

end
