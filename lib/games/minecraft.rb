require './lib/game'

class Minecraft < Game

  def auth?
    true
  end

  def split_billing?
    true
  end

  def static_addresses?
    true
  end

  def mappable?
    true
  end

  def account_provider
    Accounts::Mojang
  end

end
