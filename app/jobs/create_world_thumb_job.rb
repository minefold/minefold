class CreateWorldThumbJob < Job
  @queue = :low

  def initialize(world_id)
    @world = World.unscoped.find(world_id)
  end

  def perform!(world)
    @world.fetch_photo!
  end

end
