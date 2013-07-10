class ServerTickedJob < Job
  @queue = :high

  attr_reader :server, :uids, :timestamp

  def initialize(party_cloud_id, uids, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
    @creator = @server.creator
    @uids = uids
    @timestamp = Time.at(timestamp)
  end

  def perform
    if @creator.active_subscription?
      # TODO record something?

    else
      coin_server_tick
    end
    Server.increment_counter :minutes_played, @server.id
  end

  def coin_server_tick
    # Creator pays
    if @creator.coins <= 0
      @uids.each do |uid|
        kick_player(uid, "Out of time! Visit minefold.com to get more")
      end
    else
      @creator.spend_coins! [@uids.size, 10].min
    end

    if @creator.coins == 15
      TimeMailer.low(@creator.id).deliver
    elsif @creator.coins == 1
      TimeMailer.out(@creator.id).deliver
    end
  end

  def coin_message(player)
    minutes = (player.user.coins + 1)
    if minutes % 60 == 0
      hours = minutes / 60
      tell_player(player.uid, "#{hours} hours remaining. Visit minefold.com to get more")

    elsif player.user.coins == 10
      tell_player(player.uid, "Only #{minutes} minutes remaining! Visit minefold.com to get more")
    end

  end

  def kick_player(uid, msg)
    PartyCloud.kick_player(@server.party_cloud_id, uid, msg)
  end

  def tell_player(uid, msg)
    PartyCloud.tell_player(@server.party_cloud_id, uid, msg)
  end

end
