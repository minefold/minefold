module Atlas
  def self.map_server(server_id, snapshot_id)
    $redis.lpush('queue:default', JSON.dump(
      class: 'RenderMapWorker',
      args: [server_id, snapshot_id],
      retry: true
    ))
  end
end

