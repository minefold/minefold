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
    @featured_games = ['Minecraft'].each_with_object({}) do |name, servers|
      scope = Game.where(name: name)
      servers[scope.first] = scope.servers_count
    end
  end

  def pricing
    @packs = CoinPack.active.all
  end

  def privacy
  end

  def terms
  end

end
