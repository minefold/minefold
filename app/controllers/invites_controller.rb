class InvitesController < ApplicationController

  # expose(:creator) { User.find_by_slug!(params[:user_id]) }
  # expose(:world)   { creator.created_worlds.find_by_slug!(params[:world_id]) }
  #
  # def create
  #   params[:invite][:emails].split(', ').each do |email|
  #     if user = User.where(email: email.downcase).first
  #       if world.can_play?(user)
  #         world.whitelisted_players << user
  #         world.save
  #       end
  #     end
  #
  #     UserMailer.invite(current_user, world, email).deliver!
  #   end
  #
  #   redirect_to :back
  # end

end
