class PlayersController < ApplicationController

  expose(:creator) {User.find_by_slug!(params[:user_id])}
  expose(:world) {owner.owned_worlds.find_by_slug!(params[:world_id])}
  expose(:player) do
    world.members.find_by_slug(params[:id]) or
    User.find(params[:player_id])
  end

  def create
    world.members << player
    world.save

    redirect_to user_world_players_path(world.owner, world)
  end

  def destroy
    world.members.delete(player)
    world.save
    redirect_to user_world_players_path(world.owner, world)
  end

end
