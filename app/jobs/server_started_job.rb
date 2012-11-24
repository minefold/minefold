class ServerStartedJob < Job
  @queue = :high

  def initialize(party_cloud_server_id, host, port)
    @server = Server.find_by_party_cloud_id(party_cloud_server_id)
    @host, @port = host, port
  end

  def perform!
    @server.host = @host
    @server.port = @port
    @server.save!

    session = @server.sessions.current
    session.started_at = Time.now
    session.save!
  end

end
