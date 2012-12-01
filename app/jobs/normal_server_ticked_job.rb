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
      if @server.up?
        if @server.creator.coins > 5
          @server.creator.spend_coins!(5)
        end
      else
        raise "#{@server.id} ticked while in state:#{@server.state}"
      end
    end
  end

end
