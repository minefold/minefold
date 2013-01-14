require 'forwardable'

class GameLibrary
  extend Forwardable
  include Enumerable

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

end
