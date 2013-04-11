module PartyCloud

  def self.start_server(pc_server_id, funpack_id, data)
    enqueue 'StartServerJob', pc_server_id, funpack_id, data
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

  def self.running_server_allocations(pc_server_ids)
    pc_server_ids.each_with_object({}) do |id, h|
      if $redis.get("server:#{id}:state") == 'up'
        if alloc = $redis.get("server:#{id}:ram_alloc")
          h[id] = alloc.to_i
        end
      end
    end
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
