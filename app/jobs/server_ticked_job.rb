class ServerTickedJob < Job
  @queue = :high

  attr_reader :server, :uids, :timestamp

  def initialize(party_cloud_id, uids, timestamp)
    @server = Server.unscoped.find_by_party_cloud_id(party_cloud_id)
    @uids = uids
    @timestamp = Time.at(timestamp)
  end

  def perform
    if @server.shared?
      shared_server_tick
    else
      normal_server_tick
    end
  end
  
  def normal_server_tick
    # Creator pays
    creator = @server.creator
    
    if creator.active_subscription?
      # TODO record something?
    
    elsif creator.coins <= 0
      @uids.each do |uid|
        kick_player(uid, "Out of time! Visit minefold.com to get more")
      end
    else
      creator.spend_coins! [@uids.size, 10].min
    end

    if creator.coins == 15
      TimeMailer.low(creator.id).deliver
    elsif creator.coins == 1
      TimeMailer.out(creator.id).deliver
    end
  end
  
  def shared_server_tick
    # Players pay
    # TODO look up game type
    @players = Accounts::Mojang.where(uid: @uids).all

    @players.each do |player|
      if player.user.nil?
        # if the user has unlinked their account, kick them
        kick_player(player.uid, "Link your Minecraft account at minefold.com to play")
      elsif player.user.coins <= 0
        kick_player(player.uid, "Out of time! Visit minefold.com to get more")
      else
        coin_message(player)
        player.user.spend_coins! 1
      end

      if player.user
        if player.user.coins == 15
          TimeMailer.low(player.user.id).deliver
        elsif player.user.coins == 1
          TimeMailer.out(player.user.id).deliver
        end
      end
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
