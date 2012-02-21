class CreateWorldThumbJob
  @queue = :low

  def self.perform(world_id)
    world = World.find(world_id)
    new.process! world
  end

  def process!(world)
    puts "Fetching photo for World##{world.id}"
    world.fetch_photo!
    world.save
  end

end
