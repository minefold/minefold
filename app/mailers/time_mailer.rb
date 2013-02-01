require 'transaction_mailer'

class TimeMailer < TransactionMailer

  def low(user_id)
    @user = User.find(user_id)

    tag 'time#low'
    mail to: @user.email,
         subject: "Minefold time is low"
  end

  def out(user_id)
    @user = User.find(user_id)

    tag 'time#out'
    mail to: @user.email,
         subject: "Out of Minefold time"
  end

end
