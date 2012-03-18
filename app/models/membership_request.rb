class MembershipRequest
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :world

  belongs_to :user
  validates_presence_of :user

  def approve
    world.whitelist_player!(user)
  end

end
