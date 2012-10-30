class PartyCloud
  
  def start_server(funpack_id, settings, args={})
    enqueue 'StartWorldJob', funpack_id, settings, args
  end
  
  def import_world(world_id, url)
    enqueue 'FetchWorldJob', world_id, url
  end
  
  def stop_server(server_id)
    enqueue 'StopWorldJob', server_id
  end
  
  def kick_player(server_id, player_uid)
    enqueue 'KickPlayerJob', server_id, player_uid
  end
  
# --
  
  def enqueue(job, *args)
    queue << {'class' => job, 'args' => args}
  end
  
  def queue
    @queue ||= Resque::Queue.new('inbox', self.class.redis, Resque.coder)
  end

end
