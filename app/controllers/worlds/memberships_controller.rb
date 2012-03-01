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
      .by_username(params[:username])
      .potential_members_for(world)
      .first

    respond_with @user
  end

  def create
    authorize! :operate, world

    @user = User
      .by_username(params[:username])
      .potential_members_for(world)
      .first

    if @user
      membership = world.add_member(@user)

      world.save!

      # TODO Move to an observer
      WorldMailer.membership_created(world.id, membership.id).deliver
      track 'added member'

      respond_with membership, location: user_world_members_path(world.creator, world)
    else
      render nothing: true, status: :not_found
    end
  end

  def destroy
    authorize! :operate, world

    membership = world.memberships.find(params[:id])
    membership.delete

    world.save!

    track 'removed member'

    respond_with membership, location: user_world_members_path(world.creator, world)
  end

end
