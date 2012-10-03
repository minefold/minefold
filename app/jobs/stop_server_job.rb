class StopServerJob < Job

  def initialize(server_id)
    @server = Server.find(server_id)
  end

  def perform!
    logger.info "stopping server"
    logger.info @server.inspect
  end

end
