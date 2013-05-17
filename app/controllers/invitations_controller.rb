class InvitationsController < ApplicationController

  prepend_before_filter :authenticate_user!, only: [:create]

  expose(:user) do
    User.find_by_invitation_token(params[:invitation_token])
  end

  def show
    unless signed_in? and current_user == user
      redirect_to new_user_registration_path
    end
  end

  def create
    emails = params[:invitation][:emails].split.select{|e| e =~ /.+@.+\..+/ }

    emails.each do |email|
      invitation = Invitation.new(
        sender:  current_user,
        email:   email,
        message: params[:invitation][:message]
      )
      invitation.save!
      InvitationsMailer.invitation(invitation.id).deliver
    end

    flash[:alert] = :invitations_sent

    redirect_to bonuses_path
  end

end
