class UserMailer < ActionMailer::Base
  include Resque::Mailer

  include WorldHelper  
  helper :world

  def welcome(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Welcome to Minefold!')
  end

  def reminder(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Buy more Minefold time (running low)')
  end

  # TODO
  # def thanks(user_id)
  #   # @order = Order.find(order_id)
  #   # mail(to: @order.user.email, subject: 'Thank you for buying Minefold minutes!')
  # end

  # TODO
  # def payment_failed user_id
  #
  # end

  # class Preview < MailView
  #
  #   def invite
  #     ::UserMailer.invite User.chris, User.chris.created_worlds.first, 'dave@minefold.com'
  #   end
  #
  #   def welcome
  #     ::UserMailer.welcome User.chris.id
  #   end
  #
  #   def reminder
  #     ::UserMailer.reminder User.chris.id
  #   end
  #
  #   def thanks
  #     # order = Order.new
  #     # order.transactions.new option_selection1: 8
  #     # order.user = User.chris
  #     # order.save
  #     #
  #     # ::OrderMailer.thanks(order.id)
  #   end
  #
  # end

end
