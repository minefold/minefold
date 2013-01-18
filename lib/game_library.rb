require 'forwardable'

class GameLibrary
  extend Forwardable

  def_delegators :@games, :push, :each, :include?

  def initialize
    @games = []
  end

  def fetch(id)
    @games.find {|game| game.id == id }
  end

  def find(slug)
    @games.find {|game| game.slug == slug }
  end

  def published
    @games.select {|game| game.published? }
  end

  def playable
    @games.reject {|game| game.funpack_id.nil? }
  end

end
