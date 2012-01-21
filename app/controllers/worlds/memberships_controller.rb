class Worlds::MembershipsController < ApplicationController
  expose(:creator) { User.find_by_slug! params[:user_id] }
  expose(:world) {
    World.find_by_slug! creator.id, params[:world_id]
  }

  respond_to :html, :json

  def index
  end

  def search
    authorize! :operate, world

    @user = User
      .potential_members(world)
      .by_username(params[:username])
      .first

    respond_with @user
  end

  def create
    authorize! :operate, world

    @user = User
      .potential_members(world)
      .where(_id: params[:id])
      .first

    membership = world.add_member(@user)
    world.save

    # TODO Move to an observer
    WorldMailer.membership_created(world.id, membership.id).deliver
    track 'member added'

    respond_with membership, location: world_path(world)
  end

end
