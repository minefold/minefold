class ServerCreatedJob < Job
  @queue = :high

  attr_reader :server
  attr_reader :party_cloud_id

  def initialize(id, party_cloud_id)
    @server = Server.unscoped.find(id)
    @party_cloud_id = party_cloud_id
  end

  def perform!
    server.party_cloud_id = party_cloud_id
    server.save!
  end

end
