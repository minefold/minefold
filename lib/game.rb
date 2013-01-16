# TODO Make this require more specific to speed up tests. All it's used for is 1.day.ago and friends.
require 'active_support/core_ext'

class Game

  attr_reader :id
  attr_reader :name
  attr_reader :slug
  attr_reader :published_at

  def initialize(params)
    @id = params.fetch(:id)
    @name = params.fetch(:name)
    @slug = params.fetch(:slug)
    @published_at = params[:published_at]
  end

  def auth?
    false
  end

  def routable?
    false
  end

  def mappable?
    false
  end

  def new?
    published_at >= 2.months.ago
  end

  def published?
    !published_at.nil?
  end

# --

  def funpacks
    Funpack.where(game_id: id).all
  end

  def servers_count
    funpacks.inject(0) {|sum, fp| sum += fp.servers.count }
  end

  def to_param
    slug
  end

end
