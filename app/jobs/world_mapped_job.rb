class WorldMappedJob < Job
  def initialize(id, timestamp, map_data)
    @server = Server.unscoped.find(id)
    @timestamp, @map_data = timestamp, map_data
    @world = @server.world
  end

  def perform?
    not @world.nil?
  end

  def perform!
    @world.last_mapped_at = Time.at(@timestamp)
    # TODO Actualy sent the nice data from the mapping job.
    @world.map_data = {
      zoom_levels: @map_data['zoomLevels'],
      tile_size:   @map_data['tileSize'],
      spawn:       @map_data['markers'].find {|m| m['type'] == 'spawn'}
    }
    @world.save!
  end

end