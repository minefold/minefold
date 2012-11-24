class NormalServerTickedJob < Job
  @queue = :high

  def initialize(server_pc_id, timestamp)
    @server = Server.find_by_party_cloud_id(server_pc_id)
    @timestamp = Time.at(timestamp)
  end

  def perform!
    if @server.creator.credits <= 0
      PartyCloud.stop_server(@server.party_cloud_id)
    else
      @server.creator.increment_credits!(-5)
    end
  end

end
