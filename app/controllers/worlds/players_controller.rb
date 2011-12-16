class Worlds::PlayersController < ApplicationController

  expose(:world) {
    World.find_by_slug! params[:world_id]
  }

  expose(:player) {
    world.whitelisted_players.find_by_slug(params[:id]) or User.find(params[:player_id])
  }

  def search
    user = world.search_for_potential_player(params[:username])

    if user
      render json: user
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def ask
    world.play_requests.new user: current_user
    world.save

    WorldMailer.play_request(world.id, current_user.id).deliver

    redirect_to world_path(world)
  end

  def add
    @player = world.search_for_potential_player(params[:username])
    
    world.whitelisted_players << @player
    world.save

    WorldMailer.player_added(world.id, @player.id).deliver

    redirect_to world_path(world)
  end

  # def approve
  #   @play_request = world.play_requests.find(params[:play_request_id])
  # 
  #   world.whitelisted_players << @play_request.user
  #   world.play_requests.delete(@play_request)
  #   world.save
  # 
  #   WorldMailer.player_added(world.id, @play_request.user.id).deliver
  # 
  #   redirect_to edit_world_path(world, anchor: 'players')
  # end
  # 
  # def destroy
  #   if player.current_world == world
  #     player.current_world = nil
  #     player.save
  #   end
  # 
  #   world.whitelisted_players.delete(player)
  #   world.save
  # 
  #   redirect_to edit_world_path(world, anchor: 'players')
  # end

end
