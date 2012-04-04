class WorldObserver < Mongoid::Observer

  def before_create(world)
    world.opped_players = [world.creator.minecraft_player]
    
    world.seed ||= Time.now.to_i.to_s

    if world.world_upload
      world.world_data_file = world.world_upload.world_data_file
    end
  end

  def after_create(world)
    if world.world_upload
      Resque.push 'maps_high', class: 'Job::MapWorld', args: [world.id.to_s]
    end
  end
end
