class ServerStoppedJob < Job

  def initialize(pc_server_id)
    @server = Server.unscoped.find_by_party_cloud_id(pc_server_id)
  end

  def perform!
    session = @server.sessions.current
    session.ended_at = Time.now
    session.save!
  end

end
