class FetchCoverPhotoJob < Job
  @queue = :low

  def initialize(world_id)
    @world = World.unscoped.where(_id: world_id).first
  end

  def perform!
    @world.fetch_cover_photo!
    @world.save!
  end

end
