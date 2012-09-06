class GamesController < ApplicationController
  respond_to :html

  expose :game

  def show
    respond_with(game)
  end

end
