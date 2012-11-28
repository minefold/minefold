class NormalServerTickedJob < Job
  @queue = :high

  def initialize(server_pc_id, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(server_pc_id)
    @timestamp = Time.at(timestamp)
  end

  def perform!
    if @server.creator.coins <= 0
      PartyCloud.stop_server(@server.party_cloud_id)
    else
      @server.creator.increment_coins!(-5)
    end
  end

end
