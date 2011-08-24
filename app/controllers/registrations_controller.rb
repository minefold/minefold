class RegistrationsController < Devise::RegistrationsController

  before_filter :check_invite, :only => [:new]

  statsd_count_success :new, 'RegistrationsController.new'
  statsd_count_success :create, 'RegistrationsController.create'

protected

  def check_invite
    @invite = Invite.unclaimed.find_by_code(params[:code])
    not_found unless @invite
  end

end
