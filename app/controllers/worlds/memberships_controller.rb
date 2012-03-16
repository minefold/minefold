class Worlds::MembershipsController < ApplicationController
  respond_to :html, :json

  expose(:player) {
    MinecraftPlayer.find_by(slug: params[:player_id])
  }
  expose(:creator) {
    player.user
  }
  expose(:world) {
    creator.created_worlds.find_by(name: params[:world_id])
  }

  def index
  end

  def create
    authorize! :operate, world

    world.whitelist_player!(
      MinecraftPlayer.find_or_create_by(username: params[:username])
    )

    track 'added member'

    respond_with world, location: player_world_players_path(player, world)
  end

  def destroy
    authorize! :operate, world

    world.unwhitelist_player!(MinecraftPlayer.find_by_username(params[:id]))

    track 'removed member'

    respond_with world, location: player_world_players_path(player, world)
  end

end
