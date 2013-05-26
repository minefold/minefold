class BonusesController < ApplicationController

  def index
    @invitations = Invitation.where(sender_id: current_user.id)
  end

end
