class AdminController < ApplicationController

  before_filter :authenticate

  def index
    @users = User.all(:sort => :created_at.asc)
    @invites_claimed = Invite.claimed.count
    @invites_unclaimed = Invite.unclaimed.count
    @invites = Invite.unclaimed.order(:created_at.asc).all
    
    @world_players = []
    worlds = World.find REDIS.smembers("world:running")
    worlds.map do |world|
      player_ids = REDIS.smembers "world:#{world.id}:connected_players"
      if player_ids.size > 0
        @world_players << {
          world: world,
          players: User.find(player_ids)
        }
      end
    end

    render :layout => false
  end

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "carlsmum"
    end
  end

end
