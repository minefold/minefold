class WorldObserver < Mongoid::Observer
  def before_create world
    world.world_data_file = world.world_upload.world_data_file if world.world_upload
  end
end
