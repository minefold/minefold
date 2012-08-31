class MembershipRequest
  # include Mongoid::Document
  # include Mongoid::Timestamps::Created
  #
  # embedded_in :world
  #
  # # todo: remove this association
  # belongs_to :user
  #
  # belongs_to :minecraft_player
  # # validates_presence_of :minecraft_player
  # # validates_uniqueness_of :minecraft_player, scope: :world
  #
  # # todo: remove this method
  # def player
  #   minecraft_player || user.minecraft_player
  # end
  #
  # def approve(approver)
  #   # todo: don't use user
  #   world.whitelist_player!(player)
  #
  #   if player.user && player.user.notify?(:world_membership_added)
  #     UserMailer
  #       .membership_request_approved(player.user.id, world.id, approver.id)
  #       .deliver
  #   end
  # end
end
