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

    # Map persistant servers once a day when they shut down. Limiting to once a day stops somebody connecting and disconnecting 50 times and queing up a bunch of mapping jobs.
    if @server.world and @server.world.needs_map?
      Resque.push 'maps', class: 'MapWorldJob', args: [@server.world.id]
    end
  end

end
