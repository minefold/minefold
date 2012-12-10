class PlayerConnectedJob < Job
  @queue = :high

  def initialize(server_pc_id, uid, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(server_pc_id)
    @player = Player.minecraft.find_by_uid(uid)
    @timestamp = timestamp
  end

  def perform!

    vote = Vote.new
    vote.server = @server
    vote.user = @player.user
    vote.save!

  end
end
