class Worlds::MembershipsController < ApplicationController
  respond_to :html, :json

  expose(:player) {
    MinecraftPlayer.find_by(slug: params[:player_id])
  }

  expose(:creator) {
    player.user
  }

  expose(:world) {
    creator.created_worlds.find_by(name: params[:world_id])
  }

  def index
  end

  def search
    authorize! :operate, world

    account = MinecraftAccount
      .by_username(params[:username])
      .first

    respond_with(world.accounts.include?(account) ? nil : account)
  end

  def create
    authorize! :operate, world

    account = MinecraftAccount
      .by_username(params[:username])
      .first

    if world.accounts.include?(account)
      render nothing: true, status: :not_found
    else
      world.whitelisted << account
      world.save!

      # TODO Move to an observer
      # WorldMailer.membership_created(world.id, membership.id).deliver
      track 'added member'

      respond_with account, location: user_world_members_path(world.creator, world)
    end
  end

  def destroy
    authorize! :operate, world

    world.whitelisted.find(params[:id]).delete
    world.save!

    track 'removed member'

    respond_with membership, location: user_world_members_path(world.creator, world)
  end

end
