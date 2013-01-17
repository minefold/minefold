class GamesController < ApplicationController

  expose(:game) {
    GAMES.find(params[:id])
  }

  def show
    @popular_funpacks = game.funpacks.reject {|funpack| game.default_funpack.id == funpack.id }
  end

end
