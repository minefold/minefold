class Job
  @queue = :low

  def self.perform(*args)
    job = new(*args)

    return unless job.perform?

    begin
      job.logger.info "started"
      job.perform!
      job.logger.info "finished"
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

  def logger
    @logger ||= Rails.logger
  end

end
