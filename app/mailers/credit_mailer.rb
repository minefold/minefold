class CreditMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'admin@minefold.com'

  def low_credit user_id
    @user = User.find user_id
    mail(to: @user.email, subject: 'Minefold minutes running low')
  end

end
