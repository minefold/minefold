class Worlds::MembershipsController < ApplicationController
  expose(:world) {
    World.find_by_slug! params[:world_id]
  }

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
      .find(params[:user_id])

    world.add_member @user
    world.save

    WorldMailer.member_added(world.id, @player.id).deliver
    track 'member added'

    respond_with world
  end

end
