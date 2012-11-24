class StopServerJob < Job

  def initialize(id)
    @server = Server.find(id)
  end

  def perform!
    PartyCloud.stop_server(@server.party_cloud_id)
  end

end
