module PartyCloud

  def self.start_server(pc_server_id, funpack_id, settings)
    enqueue 'StartServerJob', pc_server_id, funpack_id, settings
  end

  def self.stop_server(pc_server_id)
    enqueue 'StopServerJob', pc_server_id
  end

  def self.import_world(pc_server_id, funpack_id, url, reply_key)
    enqueue 'ImportWorldJob', pc_server_id, funpack_id, url, reply_key
  end

  def self.kick_player(pc_server_id, player_uid, msg)
    enqueue 'KickPlayerJob', pc_server_id, player_uid, msg
  end

  def self.tell_player(pc_server_id, player_uid, msg)
    enqueue 'TellPlayerJob', pc_server_id, player_uid, msg
  end

  def self.players_online(pc_server_id)
    $redis.smembers("server:#{pc_server_id}:players")
  end

  def self.count_players_online(pc_server_id)
    $redis.scard("server:#{pc_server_id}:players")
  end

# --

  def self.enqueue(job, *args)
    Resque.push 'pc', class: job, args: args
  end
end
