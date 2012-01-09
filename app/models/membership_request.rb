class MembershipRequest
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :world
  belongs_to :user

  def approve
    world.add_member(user)
  end

end
