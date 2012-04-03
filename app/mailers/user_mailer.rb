class UserMailer < ActionMailer::Base
  include Resque::Mailer

  include WorldHelper
  helper :world

  default :from => 'Minefold <team@minefold.com>'

  def welcome(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Welcome to Minefold!')
  end

  def reminder(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Low on Minefold time!')
  end

  def credits_reset(user_id)
    @user = User.find user_id

    return unless @user.notify? :credits_reset

    track @user, 'sent reset credit email'
    mail(to: @user.email, subject: 'You have more Minefold time!')
  end

  def invite(player_id, world_id, invitee_email, message = nil)
    @player = MinecraftPlayer.find player_id
    @world = World.find world_id

    track @player.user, 'sent invite email' if @player.user
    mail(to: invitee_email, subject: "#{@player.username} wants you to play Minecraft in #{@world.name}")
  end

  def claim_account_info(player_id, email, message = nil)
    @player = MinecraftPlayer.find player_id

    track @player, 'sent claim email'
    mail(to: email, subject: "Claim #{@player.username} on Minefold")
  end

  private

  def track user, event
    Mixpanel.track event, distinct_id: user.distinct_id.to_s, mp_name_tag: user.username
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
