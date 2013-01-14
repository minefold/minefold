class StopServerJob < Job
  def initialize(id)
    @server = Server.unscoped.find(id)
  end

  def perform
    PartyCloud.stop_server(@server.party_cloud_id)
  end

end
