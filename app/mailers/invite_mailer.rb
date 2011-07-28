class InviteMailer < ActionMailer::Base
  default from: 'admin@minefold.com'

  def beta_invite(invite)
    @invite = invite
    @world = World.default
    mail(to: @invite.email, subject: 'Minefold Beta')
  end

end
