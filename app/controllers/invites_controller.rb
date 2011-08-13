class InvitesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @invite = Invite.new
  end

  def create
    invite = Invite.new email: params[:invite][:email]
    invite.creator = current_user

    if invite.valid? and invite.save and InviteMailer.beta_invite(invite).deliver
      current_user.increment referrals: 1

      current_user.reload

      render json: {email: invite.email, remaining: current_user.referrals_left}
    else
      render json: {errors: invite.errors}
    end
  end

end
