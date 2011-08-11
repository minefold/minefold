class OrderMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'admin@minefold.com'

  def reminder(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Minefold minutes running low')
  end

  def thanks(order_id)
    @order = Order.find(order_id)
    mail(to: @order.user.email, subject: 'Thank you for buying Minefold minutes!')
  end

end
