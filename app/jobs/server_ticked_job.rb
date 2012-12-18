class ServerTickedJob < Job
  @queue = :high

  attr_reader :server, :uids, :timestamp

  def initialize(party_cloud_id, uids, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
    @uids = uids
    @timestamp = Time.at(timestamp)
  end

  def perform!
    if @server.shared?
      # Players pay
      # TODO look up game type
      @players = Accounts::Mojang.where(uid: @uids).all

      @players.each do |player|
        if player.user.nil?
          kick_player(player.uid, "Link your Minecraft account at minefold.com to play")
        elsif player.user.coins <= 0
          kick_player(player.uid, "Out of coins! Visit minefold.com to get more")
        else
          coin_message(player)
          player.user.spend_coins! 1
        end
      end

    else
      # Creator pays
      if @server.creator.coins <= 0
        @uids.each do |uid|
          kick_player(uid, "Out of coins! Visit minefold.com to get more")
        end
      else
        @server.creator.spend_coins! [@uids.size, 10].min
      end
    end
  end

  def coin_message(player)
    coins = (player.user.coins + 1)
    if coins % 60 == 0
      tell_player(player.uid, "#{coins} coins remaining. Visit minefold.com to get more")

    elsif player.user.coins == 10
      tell_player(player.uid, "Only #{coins} coins remaining! Visit minefold.com to get more")
    end

  end

  def kick_player(uid, msg)
    PartyCloud.kick_player(@server.party_cloud_id, uid, msg)
  end

  def tell_player(uid, msg)
    PartyCloud.tell_player(@server.party_cloud_id, uid, msg)
  end

end
