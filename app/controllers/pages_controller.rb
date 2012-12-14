class PagesController < ApplicationController

  prepend_before_filter :authenticate_user!, only: [:welcome, :getcoins]

  def about
  end

  def getcoins
    @small_coin_pack = CoinPack.active.first
  end

  def support
  end

  def home
    @featured_games = ['Minecraft'].each_with_object({}) do |name, servers|
      scope = Game.where(name: name)
      servers[scope.first] = scope.servers_count
    end

    @coming_soon_games = ['Team Fortress', 'Counter-Strike', 'Call of Duty', 'Battlefield', 'DayZ']
  end

  def pricing
    @packs = CoinPack.active.all
  end

  def privacy
  end

  def terms
  end

end
