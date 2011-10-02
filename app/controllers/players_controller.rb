class PlayersController < ApplicationController

  expose(:creator) {User.find_by_slug!(params[:user_id])}
  expose(:world) {creator.created_worlds.find_by_slug!(params[:world_id])}
  expose(:player) do
    world.whitelisted_players.find_by_slug(params[:id]) or
    User.find(params[:player_id])
  end

  def create
    world.whitelisted_players << player
    world.save

    redirect_to user_world_players_path(world.creator, world)
  end

  def destroy
    world.whitelisted_players.delete(player)
    world.save
    redirect_to user_world_players_path(world.creator, world)
  end

end
