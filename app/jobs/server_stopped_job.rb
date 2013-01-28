class ServerStoppedJob < Job
  @queue = :low

  attr_reader :stopped_at
  attr_reader :server

  def initialize(timestamp, party_cloud_id)
    @stopped_at = Time.at(timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
  end

  def perform
    # TODO Add error checking for when the session doesn't exist
    session = server.sessions.current
    session.finish(stopped_at)
    session.save!

    server.stopped!

    Pusher.trigger("server-#{server.id}", 'server:stopped',
      state: server.state_name,
      stopped_at: stopped_at
    )
  end

end
