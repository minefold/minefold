class UserMailer < ActionMailer::Base
  include Resque::Mailer

  default from: 'team@minefold.com'
  layout 'email'

  def referral(referral)
    @referral = referral
    @world = World.default
    mail(to: @referral.email, subject: 'Minefold Beta')
  end

  def welcome(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Welcome to Minefold!')
  end

  def reminder(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Buy more Minefold time (running low)')
  end

  # TODO
  def thanks(order_id)
    # @order = Order.find(order_id)
    # mail(to: @order.user.email, subject: 'Thank you for buying Minefold minutes!')
  end

  class Preview < MailView

    def referral
      chris = User.chris
      referral = chris.referrals.new email: 'christopher.lloyd@gmail.com'
      referral.creator = chris

      ::UserMailer.referral(referral)
    end

    def welcome
      ::UserMailer.welcome User.chris.id
    end

    def reminder
      ::UserMailer.reminder User.chris.id
    end

    def thanks
      # order = Order.new
      # order.transactions.new option_selection1: 8
      # order.user = User.chris
      # order.save
      #
      # ::OrderMailer.thanks(order.id)
    end

  end

end
