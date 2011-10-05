class InvitesController < ApplicationController

  expose(:creator) {User.find_by_slug!(params[:user_id])}
  expose(:world) {creator.created_worlds.find_by_slug!(params[:world_id])}

  def create
    params[:invite][:emails].split(', ').each do |email|
      if user = User.where(email: email.downcase).first
        if world.can_play?(user)
          world.whitelisted_players << user
          world.save
        end
      else
        unless Invite.where(email: email, world_id: world.id).exists?
          invite = Invite.create(email: email, world: world)
          invite.mail.deliver!
        end
      end

      redirect_to :back
    end
  end

end
