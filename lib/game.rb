class Game

  attr_accessor :id
  attr_accessor :name
  attr_accessor :slug

  def initialize(params)
    @id = params.fetch(:id)
    @name = params.fetch(:name)
    @slug = params.fetch(:slug)
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
