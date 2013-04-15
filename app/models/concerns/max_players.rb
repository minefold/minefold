module Concerns::MaxPlayers
  extend ActiveSupport::Concern

  included do
    before_save :set_max_players
  end

  def set_max_players
    self.settings['max-players'] = creator.max_players(funpack)
  end

  def max_players
    creator.max_players(funpack)
  end

end
