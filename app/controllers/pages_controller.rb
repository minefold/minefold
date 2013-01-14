require './lib/games'

class PagesController < ApplicationController

  prepend_before_filter :authenticate_user!, only: [:welcome, :time]

  def about
  end

  def time
    @small_coin_pack = CoinPack.active.first
  end

  def support
  end

  def home
    @games = GAMES
  end

  def pricing
    @packs = CoinPack.active.all
  end

  def privacy
  end

  def terms
  end

end
