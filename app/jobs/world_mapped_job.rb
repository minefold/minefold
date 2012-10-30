class WorldMappedJob < Job
  @queue = :low

  def initialize(id, timestamp, map_data)
    @world = World.find_by_party_cloud_id(id)
    @timestamp, @map_data = timestamp, map_data
  end
  
  def perform?
    not @world.nil?
  end

  def perform!
    @world.last_mapped_at = Time.at(@timestamp)
    @world.map_data = @map_data
    @world.save!
  end

end
