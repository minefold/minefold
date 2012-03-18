class Worlds::MembershipRequestsController < ApplicationController
  respond_to :html, :json

  prepend_before_filter :authenticate_user!

  expose(:player) {
    MinecraftPlayer.find_by(slug: params[:player_id])
  }
  expose(:creator) {
    player.user
  }
  expose(:world) {
    creator.created_worlds.find_by(name: params[:world_id])
  }

  expose(:membership_request) {
    if params[:id]
      world.membership_requests.find(params[:id])
    else
      world.membership_requests.find_or_initialize_by user: current_user
    end
  }

  def create
    authorize! :read, world

    if membership_request.new_record? and world.save!
      world.opped_players.each do |op|
        WorldMailer
          .membership_request_created(world.id, membership_request.id, op.user.id)
          .deliver
      end
      track 'created membership request'
    end

    respond_with world, location: player_world_path(player, world)
  end

  def approve
    authorize! :operate, world

    membership_request.approve
    membership_request.destroy

    if world.save!
      WorldMailer
        .membership_request_approved(world.id, membership_request.user.id)
        .deliver

      track 'approved membership request'
    end

    respond_with world, location: player_world_path(player, world)
  end

  def destroy
    authorize! :operate, world

    membership_request.destroy

    track 'ignored membership request'

    respond_with world, location: player_world_path(player, world)
  end
end
