class ServerBackedUpJob < Job
  @queue = :high

  attr_accessor :server
  attr_accessor :snapshot_id
  attr_accessor :url

  def initialize(server_party_cloud_id, snapshot_id, url)
    @server = Server.unscoped.find_by_party_cloud_id(server_party_cloud_id)
    @snapshot_id, @url = snapshot_id, url
  end

  def perform!
    snapshot = server.snapshots.create(
      party_cloud_id: snapshot_id,
      url: url
    )

    # Map persistant servers once a day
    if snapshot.needs_map?
      Resque.push 'maps', class: 'MapWorldJob', args: [
        server.id,
        snapshot.id,
        snapshot.url,
        shapshot.server.settings['seed']
      ]

      shapshot.map_queued_at = Time.now
      snapshot.save!
    end
  end

end
