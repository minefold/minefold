class ServerBackedUpJob < Job
  @queue = :high

  def initialize(pc_server_id, snapshot_id, url)
    @server = Server.unscoped.find_by_party_cloud_id(pc_server_id)
    @snapshot_id, @url = snapshot_id, url
  end

  def perform!
    @server.world = World.new(
      party_cloud_id: @snapshot_id,
      legacy_url: @url
    )
    @server.save!
  end

end
