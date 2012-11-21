class ServerStoppedJob < Job

  def initialize(pc_server_id)
    @server = Server.find_by_party_cloud_id(pc_server_id)
  end

  def perform!
    # Map persistant servers once a day when they shut down. Limiting to once a day stops somebody connecting and disconnecting 50 times and queing up a bunch of mapping jobs.
    if @server.game.persistant? and not @server.world.last_mapped_at.today?
      Resque.push 'maps', class: 'MapWorldJob', args: [@server.world.id]
    end

    @server.stopped!
  end

end
