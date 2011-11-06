class PlayersController < ApplicationController

  expose(:world) {
    World.find_by_slug! params[:world_id]
  }

  expose(:player) do
    world.whitelisted_players.find_by_slug(params[:id]) or User.find(params[:player_id])
  end

  def search
    user = world.available_player(params[:username]).first

    if user
      render json: user
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def ask
    world.play_requests.new user: current_user
    world.save

    redirect_to world_path(world)
  end

  def add
    world.whitelisted_players << player
    world.save

    redirect_to world_players_path(world)
  end

  def approve
    @play_request = world.play_requests.find(params[:play_request_id])

    world.whitelisted_players << @play_request.user
    world.play_requests.delete(@play_request)
    world.save

    redirect_to :back
  end

  def destroy
    if player.current_world == world
      player.current_world = nil
      player.save
    end

    world.whitelisted_players.delete(player)
    world.save

    redirect_to world_players_path(world)
  end

end
