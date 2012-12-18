class PlayerConnectedJob < Job
  @queue = :high

  attr_accessor :server
  attr_accessor :account
  attr_accessor :timestamp

  def initialize(server_pc_id, uid, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(server_pc_id)
    @account = Accounts::Mojang.find_by_uid(uid)
    @timestamp = timestamp
  end

  def perform!
  end

end
