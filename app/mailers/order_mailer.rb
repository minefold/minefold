class OrderMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'theteam@minefold.com'
  layout 'email'

  def reminder(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Buy more Minefold time (running low)')
  end

  def thanks(order_id)
    @order = Order.find(order_id)
    mail(to: @order.user.email, subject: 'Thank you for buying Minefold minutes!')
  end

  class Preview < MailView

    def reminder
      ::OrderMailer.reminder(User.chris.id)
    end

    def thanks
      ::OrderMailer.thanks(@order.first)
    end

  end

end
