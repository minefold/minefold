class PlayerConnectedJob < Job
  @queue = :high

  def initialize(server_pc_id, uid)
    @server = Server.unscoped.find_by_party_cloud_id(server_pc_id)
    @player = Player.minecraft.find_by_uid(uid)
  end

  def perform!
  end
end
