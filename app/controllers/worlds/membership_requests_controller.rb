class Worlds::MembershipRequestsController < ApplicationController
  respond_to :html, :json

  prepend_before_filter :authenticate_user!

  expose(:creator) { User.find_by_slug!(params[:user_id]) }
  expose(:world) { World.find_by_creator_and_slug!(creator, params[:world_id]) }

  expose(:membership_request) {
    if params[:id]
      world.membership_requests.find(params[:id])
    else
      world.membership_requests.find_or_initialize_by user: current_user
    end
  }

  def create
    authorize! :read, world

    if membership_request.new_record? and membership_request.save
      WorldMailer
        .membership_request_created(world.id, membership_request.id)
        .deliver

      track 'created membership request'
    end

    respond_with world, location: user_world_path(world.creator, world)
  end

  def approve
    authorize! :operate, world

    membership_request.approve
    membership_request.destroy

    WorldMailer
      .membership_request_approved(world.id, membership_request.user.id)
      .deliver

    track 'approved membership request'

    respond_with world, location: user_world_path(world.creator, world)
  end

  def destroy
    authorize! :operate, world

    membership_request.destroy

    track 'ignored membership request'

    respond_with world, location: user_world_path(world.creator, world)
  end
end
