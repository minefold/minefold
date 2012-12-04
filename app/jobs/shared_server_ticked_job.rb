class SharedServerTickedJob < Job
  @queue = :high

  def initialize(server_pc_id, player_ids, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(server_pc_id)
    # TODO look up game type
    @players = @server.funpack.game.players.where(id: player_ids).all
    @timestamp = Time.at(timestamp)
  end

  def perform!
    if @server.shared?
      # Players pay
      @players.each do |player|
        if player.user.coins <= 0
          kick_the_cunt(player)
        else
          player.user.spend_coins! 1
        end
      end

    else
      # Cretor pays
      if server.creator.coins <= 0
        @players.each do |player|
          kick_the_cunt(player)
        end
      else
        @server.creator.spend_coins! [@players.size, 10].min
      end

    end
  end

  def kick_the_cunt(player)
    PartyCloud.kick_player(@server.party_cloud_id, player.uid)
  end

end
