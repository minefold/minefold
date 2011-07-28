class RegistrationsController < Devise::RegistrationsController

  before_filter :check_invite, :only => [:new]

protected

  def check_invite
    @invite = Invite.unclaimed.find_by_code(params[:code])
    not_found unless @invite
  end

end
