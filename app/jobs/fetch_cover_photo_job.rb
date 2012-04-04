class FetchCoverPhotoJob < Job
  @queue = :low

  def initialize(world_id)
    @world = World.unscoped.find(world_id)
  end

  def perform!
    @world.fetch_cover_photo!
    @world.save!
  end

end
