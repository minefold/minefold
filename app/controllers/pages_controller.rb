class PagesController < ApplicationController

  prepend_before_filter :authenticate_user!, :only => [:welcome]

  def about
  end

  def freetime
  end

  def support
  end

  def home
    @featured_games = ['Minecraft'].each_with_object({}) do |name, servers|
      scope = Game.where(name: name)
      servers[scope.first] = scope.servers_count
    end
    
    @coming_soon_games = ['Team Fortress 2', 'Counter-Strike: Go', 'Call of Duty', 'DayZ']
  end

  def jobs
  end

  def pricing
    @packs = CreditPack.active.all
  end

  def privacy
  end

  def terms
  end

end
