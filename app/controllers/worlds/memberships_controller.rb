class Worlds::MembershipsController < ApplicationController
  respond_to :html, :json

  expose(:player) {
    MinecraftPlayer.find_by_username(params[:player_id])
  }
  expose(:creator) {
    player.user or raise NotFound
  }
  expose(:world) {
    creator.created_worlds.find_by(slug: params[:world_id].downcase)
  }

  def index
  end

  def create
    authorize! :operate, world

    slug = MinecraftPlayer.sanitize_username(params[:username])
    @new_player = MinecraftPlayer.where(slug: slug).first
    unless @new_player
      @new_player = MinecraftPlayer.create(username: params[:username])
    end

    if @new_player.valid?
      if world.whitelist_player!(@new_player)
        if user = @new_player.user
          if user.notify? :world_membership_added
            WorldMailer.membership_created(world.id, current_user.id, user.id).deliver
          end
        end
        track 'added member', 'new player' => @new_player.user.nil?.to_s
      end
    end

    respond_with(world) do |format|
      if @new_player.valid?
        format.html { redirect_to player_world_players_path(player, world) }
      else
        format.html { render action: :index }
      end
    end
  end

  def destroy
    authorize! :operate, world

    world.unwhitelist_player!(MinecraftPlayer.find_by_username(params[:id]))

    track 'removed member'

    respond_with world, location: player_world_players_path(player, world)
  end

end
