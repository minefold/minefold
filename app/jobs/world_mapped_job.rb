class WorldMappedJob < Job
  @queue = :low

  def initialize(world_id, map_data)
    @world = World.unscoped.where(_id: world_id).first
    @map_data = map_data
  end
  
  def perform?
    not @world.destroyed?
  end

  def perform!
    @world.last_mapped_at = Time.now
    @world.map_data = @map_data
    @world.save!

    Resque.enqueue(FetchCoverPhotoJob, @world.id)
  end

end