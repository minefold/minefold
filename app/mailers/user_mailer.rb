class UserMailer < ActionMailer::Base
  default from: 'team@minefold.com'

  layout 'email'

  def referral(referral)
    @referral = referral
    @world = World.default
    mail(to: @referral.email, subject: 'Minefold Beta')
  end

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Minefold')
  end

  class Preview < MailView

    def referral
      chris = User.chris
      referral = chris.referrals.new email: 'christopher.lloyd@gmail.com'
      referral.creator = chris

      UserMailer.referral(referral)
    end

    def welcome
      chris = User.chris
      UserMailer.welcome(chris)
    end

  end

end
