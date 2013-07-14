class ServerObserver < ActiveRecord::Observer

  def after_save(server)
    Resque.enqueue(PusherJob, server.channel_name, 'changed',
      ServerSerializer.new(server).payload
    )
    cache_server_info(server)
  end

  def cache_server_info(server)
    $redis.hset 'server-info:party-cloud-id', server.id, server.party_cloud_id
    $redis.hset 'server-info:motd', server.id, server.name
  end
end
