class AdminController < ApplicationController

  http_basic_authenticate_with name: 'admin', password: 'carlsmum'

  def index
    # @users = User.all(:sort => :created_at.asc)
    # @invites_claimed = Invite.claimed.count
    # @invites_unclaimed = Invite.unclaimed.count
    # @invites = Invite.unclaimed.order(:created_at.asc).all
    #
    # @running_worlds = World.find REDIS.smembers('world:running')
    # @worlds = World.all
  end

  def worlds
    @worlds = World.sort(:created_at).all
  end

  def users
    @users = User.sort(:created_at).all
  end

end
