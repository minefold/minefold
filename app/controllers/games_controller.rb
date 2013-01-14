class GamesController < ApplicationController

  expose(:game) {
    GAMES.find(params[:id])
  }

  def show
  end

end
