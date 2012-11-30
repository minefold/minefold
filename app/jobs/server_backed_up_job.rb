class ServerBackedUpJob < Job
  @queue = :high

  def initialize(pc_server_id, snapshot_id, url)
    @server = Server.unscoped.find_by_party_cloud_id(pc_server_id)
    @snapshot_id, @url = snapshot_id, url
  end

  def perform!
    if not @server.world
      @server.world = World.new
    end

    @server.world.party_cloud_id = @snapshot_id
    @server.world.legacy_url = @url
    @server.world.save!
    
    # Map persistant servers once a day. Limiting to once a day stops somebody connecting and disconnecting 50 times and queing up a bunch of mapping jobs.
    if @server.world.needs_map?
      Resque.push 'maps', class: 'MapWorldJob', args: [
        @server.id, 
        @url,
        @server.settings['seed']
      ]
    end
  end

end
