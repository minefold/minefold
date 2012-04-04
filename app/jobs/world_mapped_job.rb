class WorldMappedJob < Job
  @queue = :low

  def initialize(world_id, map_data)
    @world = World.unscoped.find(world_id)
    @map_data = map_data
  end
  
  def perform?
    not @world.destroyed?
  end

  def perform!
    @world.update_attributes last_mapped_at: Time.now,
                             map_data: @map_data

    Resque.enqueue(FetchCoverPhotoJob, @world.id)
  end

end