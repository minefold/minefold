class ServerStartedJob < Job
  @queue = :high

  def initialize(pc_server_id, host, port)
    @server = Server.find_by_party_cloud_id(pc_server_id)
    @host, @port = host, port
  end

  def perform!
    @server.started!(@host, @port)
  end

end
