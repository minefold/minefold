class WorldObserver < Mongoid::Observer

  def before_create(world)
    world.ops = [world.creator.minecraft_player]

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
