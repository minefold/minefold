class Job
  @queue = :low

  def self.perform(*args)
    job = new(*args)

    return unless job.perform?

    begin
      job.logger.info "started #{self.name}"
      job.perform!
      job.logger.info "finished #{self.name}"
    rescue => e
      job.logger.warn e
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
