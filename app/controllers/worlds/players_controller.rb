class Worlds::PlayersController < ApplicationController

  expose(:world) {
    World.find_by_slug! params[:world_id]
  }
  
  expose(:play_request) { world.play_requests.find params[:id] }
  
  before_filter :ensure_op, :only => [:add, :approve, :destroy]

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
    @player = world.find_potential_player(params[:id])
    
    world.add_player @player
    world.save

    WorldMailer.player_added(world.id, @player.id).deliver
    track 'player added'
    
    redirect_to world_path(world)
  end

  def approve
    player = play_request.user
    if player.current_world == nil
      player.current_world = world
      player.save
    end

    play_request.destroy
    
    world.add_player player
    world.save
  
    WorldMailer.player_added(world.id, player.id).deliver
  
    redirect_to world_path(world)
  end
  
  def destroy
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

  private
  
  def ensure_op
    raise 'Must be op to perform this operation' unless world.opped? current_user
  end
end
