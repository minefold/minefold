class StartServerJob < Job
  @queue = :high

  def initialize(server_id)
    @server = Server.find(server_id)
  end

  def perform!
    logger.info "starting server"
    logger.info @server.inspect
  end

end
