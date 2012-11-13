class InvitationsController < ApplicationController\

  expose(:user) do
    User.where(invitation_token: params[:id]).first!
  end

  def show
    unless signed_in? and current_user == user
      redirect_to new_user_registration_path(i: user.invitation_token)
    end
  end

end
