class SharedServerTickedJob < Job
  @queue = :high

  def initialize(server_pc_id, uids, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(server_pc_id)
    @uids = uids
    @timestamp = Time.at(timestamp)
  end

  def perform!
    if @server.shared?
      # Players pay
      # TODO look up game type
      @players = @server.funpack.game.players.where(uid: uids).all

      @players.each do |player|
        if player.user.coins <= 0
          kick_the_cunt(player.uid)
        else
          player.user.spend_coins! 1
        end
      end

    else
      # Cretor pays
      if @server.creator.coins <= 0
        @uids.each do |uid|
          kick_the_cunt(uid)
        end
      else
        @server.creator.spend_coins! [@uids.size, 10].min
      end

    end
  end

  def kick_the_cunt(uid)
    PartyCloud.kick_player(@server.party_cloud_id, uid)
  end

end
