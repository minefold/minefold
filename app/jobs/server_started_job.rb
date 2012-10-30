class ServerStartedJob < Job
  @queue = :high

  def initialize(id, state, party_cloud_id, world_id)
    @server = Server.find(id)
    @state, @party_cloud_id, @world_id = state, party_cloud_id, world_id
  end
  
  def perform!
    @server.party_cloud_id = @party_cloud_id
    @server.world.build(
      party_cloud_id: @world_id
    )
    
    # TODO Do stuff with the server state
    raise 'TODO'
  end

end
