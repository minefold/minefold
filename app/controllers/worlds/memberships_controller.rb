class Worlds::MembershipsController < ApplicationController
  respond_to :html, :json

  expose(:creator) { User.find_by_slug!(params[:user_id]) }
  expose(:world) {
    World.find_by_creator_and_slug!(creator, params[:world_id])
  }

  def index
  end

  def search
    authorize! :operate, world

    @user = User
      .potential_members_for(world)
      .by_username(params[:username])
      .first

    respond_with @user
  end

  def create
    authorize! :operate, world

    @user = User
      .potential_members_for(world)
      .where(_id: params[:id])
      .first

    membership = world.add_member(@user)

    # TODO Move to an observer
    WorldMailer.membership_created(world.id, membership.id).deliver
    track 'added member'

    respond_with membership, location: world_path(world)
  end

end
