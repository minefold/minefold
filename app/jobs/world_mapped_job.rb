class WorldMappedJob < Job
  @queue = :low

  def initialize(world_id, map_data)
    @world = World.find(world_id)
    @map_data = map_data
  end
  
  def perform?
    not @world.destroyed?
  end

  def process!
    @world.update_attributes last_mapped_at: Time.now,
                             map_data: @map_data

    Resque.enqueue(CreateWorldThumbJob, @world.id)
  end

end