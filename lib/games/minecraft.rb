require './lib/game'

class Minecraft < Game

  def auth?
    true
  end

  def routable?
    true
  end

  def mappable?
    true
  end

  def account_provider
    Accounts::Mojang
  end

end
