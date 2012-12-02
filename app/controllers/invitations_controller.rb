class InvitationsController < ApplicationController\

  expose(:user) do
    User.find_by_invitation_token(params[:invitation_token])
  end

  def show
    unless signed_in? and current_user == user
      redirect_to new_user_registration_path
    end
  end

end
