class NormalServerTickedJob < Job
  @queue = :high

  def initialize(server_pc_id, timestamp)
    @server = Server.find_by_party_cloud_id(server_pc_id)
    @timestamp = Time.at(timestamp)
  end

  def perform!
  end

end
