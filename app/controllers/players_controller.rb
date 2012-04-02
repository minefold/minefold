class PlayersController < ApplicationController
  
  before_filter :redirect_to_correct_case
  
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
  
  private
  
  def redirect_to_correct_case
    if params[:id] and params[:id] != player.slug
      redirect_to player_path(player), status: :moved_permanently
    end
  end
  

end
