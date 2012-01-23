class WorldMappedJob
  @queue = :low
  
  def self.perform world_id, map_data
    world = World.find(world_id)
    world.last_mapped_at = Time.now
    world.map_data = map_data
    world.save!
    
    puts "world:#{world.id} mapped at #{world.last_mapped_at}"
  end
end