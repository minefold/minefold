class AdminController < ApplicationController

  http_basic_authenticate_with name: 'admin', password: 'carlsmum'
  layout nil

  def index
    @current_players_count = REDIS.hlen 'players:playing'
    @users = User.order_by([:created_at, :desc]).all
  end

end
