class Worlds::MembershipRequestsController < ApplicationController
  expose(:creator) { User.find_by_slug! params[:user_id] }
  expose(:world) {
    World.find_by_slug! creator.id, params[:world_id]
  }

  expose(:membership_request) {
    if params[:id]
      world.membership_requests.find(params[:id])
    else
      world.membership_requests.find_or_initialize_by user: current_user
    end
  }

  respond_to :json

  def create
    authorize! :read, world

    if membership_request.save and membership_request.new_record?
      WorldMailer
        .membership_request_created(world.id, membership_request.id)
        .deliver

      track 'created membership request'
    end

    respond_with world, location: world_path(world)
  end

  def approve
    authorize! :operate, world

    membership_request.approve
    membership_request.destroy

    WorldMailer
      .membership_request_approved(world.id, membership_request.user.id)
      .deliver

    track 'approved membership request'

    respond_with world, location: world_path(world)
  end

  def destroy
    authorize! :operate, world

    membership_request.destroy

    track 'ignored membership request'

    respond_with world, location: world_path(world)
  end

end
