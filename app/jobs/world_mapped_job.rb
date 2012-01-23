class WorldMappedJob
  @queue = :low
  
  def self.perform world_id, map_data
    world = World.find(world_id)
    world.set :last_mapped_at, Time.now
    world.set :map_data, map_data
    
    puts "world:#{world.id} mapped at #{world.last_mapped_at}"
  end
end