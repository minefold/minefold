# should be run about once a day

class CompactSnapshotsJob < Job
  @queue = :low

  def initialize(server_id)
    @server = Server.unscoped.find(server_id)
  end

  def perform
    PartyCloud::Server.new(@server.party_cloud_id).compact_snapshots!
  end
end
