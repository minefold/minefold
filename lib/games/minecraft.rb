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

  def default_funpack
    @default_funpack ||= Funpack.find(1)
  end

end
