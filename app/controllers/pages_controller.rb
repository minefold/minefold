require './lib/games'

class PagesController < ApplicationController

  prepend_before_filter :authenticate_user!, only: [:welcome, :time]

  def about
  end

  def developers
  end

  def features
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
    # flash[:error] = 'Your card was declined'
    @packs = CoinPack.active.all
  end

  def privacy
  end

  def terms
  end

end
