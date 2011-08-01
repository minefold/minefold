class AdminController < ApplicationController

  before_filter :authenticate

  def index
    @users = User.all(:sort => :created_at.asc)
    @invites_claimed = Invite.claimed.count
    @invites_unclaimed = Invite.unclaimed.count
    @invites = Invite.unclaimed.order(:created_at.asc).all

    @running_worlds = World.find REDIS.smembers('world:running')
    render :layout => false
  end

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "carlsmum"
    end
  end

end
