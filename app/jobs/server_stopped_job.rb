class ServerStoppedJob < Job

  def initialize(pc_server_id)
    @server = Server.unscoped.find_by_party_cloud_id(pc_server_id)
  end

  def perform!
    session = @server.sessions.current
    session.ended_at = Time.now
    session.save!

    # Clears any stop server jobs that may be queued up. This is in the case that the server is prematurely stopped.
    Resque.remove_delayed(StopServerJob, @server.id)
  end
end
