class CreateWorldThumbJob
  @queue = :low

  def self.perform(world_id)
    world = World.unscoped.find(world_id)
    return if world.destroyed?

    new.process! world
  end

  def process!(world)
    puts "Fetching photo for World##{world.id}"
    world.fetch_photo!
    world.save
  end

end
