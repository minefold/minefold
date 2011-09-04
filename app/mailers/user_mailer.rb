class UserMailer < ActionMailer::Base
  default from: 'admin@minefold.com'

  def referral(referral)
    @referral = referral
    @world = World.default
    mail(to: @referral.email, subject: 'Minefold Beta')
  end

  class Preview < MailView

    def referral
      chris = User.chris
      referral = chris.referrals.new email: 'christopher.lloyd@gmail.com'
      referral.creator = chris

      UserMailer.referral(referral)
    end

  end

end
