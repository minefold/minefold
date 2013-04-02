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
    current_referrals = current_user.bonuses
    
    for email in params[:referral][:emails].split.select{|e| e =~ /.+@.+\..+/ }
      referral = Bonuses::ReferredFriend.where("data -> 'email' = ?", email).first
      if referral.nil?
        referral = Bonuses::ReferredFriend.create(
          user: current_user,
          email: email
        )
      end
    end
    
    flash[:success] = "Invitations sent!"
    
    redirect_to url_for(
      :controller => :invitations, 
      :action => :show, 
      invitation_token: current_user.invitation_token
    )
  end

end
