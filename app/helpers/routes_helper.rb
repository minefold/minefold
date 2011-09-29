# encoding: utf-8

module RoutesHelper

  # new_user_worlds
  def new_worlds_path
    new_user_worlds_path(current_user)
  end

  # policy_user_upload
  def policy_upload_path
    policy_user_upload_path(current_user)
  end

  # user_upload
  def upload_path
    user_upload_path(current_user)
  end

  # new_user_upload
  def new_upload_path
    new_user_upload_path(current_user)
  end

  # map_user_world
  def map_world_path(world)
    map_user_world_path(world.owner, world)
  end

  # play_user_world
  def play_world_path(world)
    play_user_world_path(world.owner, world)
  end

  # user_world_wall_items
  def world_wall_items_path(world)
    user_world_wall_items_path(world.owner, world)
  end

  # user_world_players
  def world_players_path(world)
    user_world_players_path(world.owner, world)
  end

  # user_world_player
  def world_player_path(world, player)
    user_world_player_path(world.owner, world, player)
  end

  # edit_user_world
  def edit_world_path(world)
    edit_user_world_path(world.owner, world)
  end

  # user_world
  def world_path(world, opts={})
    user_world_path(world.owner, world, opts)
  end

  def worlds_path
    users_worlds_path(current_user)
  end

end
