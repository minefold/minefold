class ReferralsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @referral = current_user.referrals.new
  end

  statsd_count_success :index, 'InvitesController.index'

  def create
    referral = current_user.referrals.new params[:referral]

    if referral.valid? and
       referral.save and
       UserMailer.refer(referral).deliver
      render json: {remaining: current_user.referrals_left}
    else
      render json: {errors: invite.errors}
    end
  end

  statsd_count_success :create, 'InvitesController.create'

end
