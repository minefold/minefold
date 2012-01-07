class Worlds::PlayersController < ApplicationController

  expose(:world) {
    World.find_by_slug! params[:world_id]
  }

  expose(:play_request) { world.play_requests.find params[:id] }

  def search
    authorize! :operate, world

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
    authorize! :operate, world

    @player = world.find_potential_player(params[:id])

    world.add_player @player
    world.save

    WorldMailer.player_added(world.id, @player.id).deliver
    track 'player added'

    redirect_to world_path(world)
  end

  def approve
    authorize! :operate, world

    player = play_request.user
    if player.current_world == nil
      player.current_world = world
      player.save
    end

    play_request.destroy

    world.add_player player
    world.save

    WorldMailer.player_added(world.id, player.id).deliver
    track 'player added'

    redirect_to world_path(world)
  end

  def destroy
    authorize! :operate, world

    player = play_request.user
    if player.current_world == world
      player.current_world = nil
      player.save
    end

    play_request.destroy

    world.memberships.where(user_id: player.id).destroy
    world.save

    redirect_to world_path(world)
  end

end
