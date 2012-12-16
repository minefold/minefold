class ServerStartedJob < Job
  @queue = :high

  def initialize(party_cloud_server_id, host, port)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_server_id)
    @host, @port = host, port
  end

  def perform!
    # if not @server.shared?
    #   @server.host = @host
    #   @server.port = @port
    #   @server.save!
    # end

    session = @server.sessions.current
    session.started_at = Time.now
    session.save!

    Mixpanel.track 'Started server',
      distinct_id: @server.creator.distinct_id,
      name: @server.name,
      shared: @server.shared?
  end

end
