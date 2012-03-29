class MembershipRequest
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :world

  belongs_to :minecraft_player
  validates_presence_of :minecraft_player

  def approve
    world.whitelist_player!(minecraft_player)
  end

end
