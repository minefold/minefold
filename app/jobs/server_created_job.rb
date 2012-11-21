class ServerCreatedJob < Job
  @queue = :high

  def initialize(server_id, party_cloud_id)
    @server = Server.find(server_id)
    @party_cloud_id = party_cloud_id
  end

  def perform!
    @server.party_cloud_id = @party_cloud_id
    @server.save!
  end
end
