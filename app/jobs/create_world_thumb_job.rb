class CreateWorldThumbJob
  @queue = :low

  def self.perform(world_id)
    world = World.find(world_id)
    new(world).process!
  end

  def initialize(world)
    @world = world
  end

  def process!
    remote_base = File.join("http:#{@world.map_assets_url}", 'base.png')
    puts remote_base

    @world.remote_thumb_url = remote_base
    @world.save
  end

end
