class SharedServerTickedJob < Job
  @queue = :high

  def initialize(server_pc_id, player_uids, timestamp)
    @server = Server.find_by_party_cloud_id(server_pc_id)
    # TODO look up game type
    @players = @server.funpack.game.players.where(uid: player_uids).all
    @timestamp = Time.at(timestamp)
  end

  def perform!
    @players.each do |player|
      if player.user.credits <= 0
        PartyCloud.kick_player(@server.party_cloud_id, player.uid)
      else
        player.user.increment_credits!(-1)
      end
    end
  end

end
