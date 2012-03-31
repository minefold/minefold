class Worlds::MembershipsController < ApplicationController
  respond_to :html, :json

  expose(:player) {
    MinecraftPlayer.find_by_username(params[:player_id])
  }
  expose(:creator) {
    player.user
  }
  expose(:world) {
    creator.created_worlds.find_by(slug: params[:world_id].downcase)
  }

  def index
  end

  def create
    authorize! :operate, world

    new_player = MinecraftPlayer.find_or_create_by(username: params[:username])
    world.whitelist_player!(new_player)

    if user = new_player.user
      WorldMailer.membership_created(world.id, current_user.id, user.id).deliver
    end

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
