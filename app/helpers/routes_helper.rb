# encoding: utf-8

module RoutesHelper

  def world_path(*args)
    user_world_path(args.first.owner, *args)
  end

  def world_url(*args)
    user_world_url(args.first.owner, *args)
  end


  def worlds_path(*args)
    user_worlds_path(*args)
  end

  def edit_world_path(world)
    edit_user_world_path(world.owner, world)
  end

  def map_world_path(world)
    map_user_world_path(world.owner, world)
  end

  def photos_world_path(world)
    photos_user_world_path(world.owner, world)
  end

  def play_world_path(world)
    play_user_world_path(world.owner, world)
  end

  def play_request_world_path(world)
    play_request_user_world_path(world.owner, world)
  end

end
