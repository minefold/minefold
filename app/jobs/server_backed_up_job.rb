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
  end

end
