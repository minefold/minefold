class StaticGameConstraint

  attr_reader :games

  def initialize(games)
    @games = games
  end

  def matches?(req)
    !!( games.find(req.params['game_id'] || req.params['id']) )
  end

end
