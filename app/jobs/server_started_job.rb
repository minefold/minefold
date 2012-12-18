class ServerStartedJob < Job
  @queue = :high

  attr_reader :server
  attr_reader :host
  attr_reader :port
  attr_reader :start_at

  def initialize(party_cloud_id, host, port, timestamp=nil)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
    @host, @port = host, port

    @started_at = if timestamp.nil?
      Time.now
    else
      Time.at(timestamp)
    end
  end

  def perform!
    session = server.sessions.current

    # In the case where either jobs have been lost or processed out of order, this just continues any open sessions and moves the started_at time *back* if needed. We don't have to be super precise with ServerSessions, they're just for displaying to users (not billing).
    if session.started_at > started_at
      session.started_at = started_at
    end

    session.save!

    Mixpanel.track 'Started server',
      distinct_id: server.creator.distinct_id,
      name: server.name,
      shared: server.shared?
  end

end
