class OrderMailer < ActionMailer::Base
  include Resque::Mailer

  default from: 'team@minefold.com'
  layout 'email'

  def thanks(order_id)
    @order = Order.find(order_id)
    mail(to: @order.user.email, subject: 'Thank you for buying Minefold minutes!')
  end

  class Preview < MailView

    def thanks
      order = Order.new
      order.transactions.new option_selection1: 8
      order.user = User.chris
      order.save

      ::OrderMailer.thanks(order.id)
    end

  end

end
