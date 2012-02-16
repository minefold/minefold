class WorldObserver < Mongoid::Observer

  def before_create(world)
    if world.world_upload
      world.world_data_file = world.world_upload.world_data_file
    end
  end

end
