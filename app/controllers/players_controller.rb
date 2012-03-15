class PlayersController < ApplicationController
  respond_to :html

  expose(:player) {
    MinecraftPlayer.find_by_username(params[:id])
  }

  def new
  end

  def create
  end

  def show
  end

end
