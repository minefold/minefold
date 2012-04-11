class Worlds::MembershipRequestsController < ApplicationController
  respond_to :html, :json

  prepend_before_filter :authenticate_user!

  expose(:player) {
    MinecraftPlayer.find_by_username(params[:player_id])
  }

  expose(:creator) {
    player.user
  }

  expose(:world) {
    creator.created_worlds.find_by(slug: params[:world_id].downcase)
  }

  expose(:membership_request) {
    if params[:id]
      world.membership_requests.find(params[:id])
    else
      world.membership_requests.find_or_initialize_by minecraft_player: current_user.minecraft_player
    end
  }

  def create
    authorize! :read, world

    if membership_request.new_record?
      world.membership_requests.push(membership_request)
      world.save!
      # raise world.membership_requests.inspect
      world.opped_players.each do |op|
        if op.user and op.user.notify?(:world_membership_request_created)
          WorldMailer
            .membership_request_created(world.id, membership_request.id, op.user.id)
            .deliver
        end
      end
      track 'created membership request'
    end

    respond_with world, location: player_world_path(world.creator.minecraft_player, world)
  end

  def approve
    authorize! :operate, world

    player = membership_request.player
    membership_request.approve(current_user)
    membership_request.destroy

    track 'approved membership request'
    flash[:notice] = "Approved membership request"

    respond_with world, location: player_world_players_path(world.creator.minecraft_player, world)
  end

  def destroy
    authorize! :operate, world

    membership_request.destroy

    track 'ignored membership request'

    respond_with world, location: player_world_players_path(world.creator.minecraft_player, world)
  end
end
