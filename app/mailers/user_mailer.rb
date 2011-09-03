class UserMailer < ActionMailer::Base
  default from: 'admin@minefold.com'

  def welcome(invite)
    @invite = invite
    @world = World.default
    mail(to: @invite.email, subject: 'Minefold Beta')
  end

  class Preview < MailView

    def welcome
    end

  end

end
