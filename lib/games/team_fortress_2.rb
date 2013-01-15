require './lib/game'

class TeamFortress2 < Game

  def auth?
    false
  end

  def routable?
    false
  end

  def mappable?
    false
  end

  # TODO Fix
  def default_funpack
    @default_funpack ||= Funpack.find(4)
  end

end
