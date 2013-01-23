class CoinsMailer < ActionMailer::Base
  include Resque::Mailer

  add_template_helper ActionView::Helpers::DateHelper


  def low_coins(user_id)
    @resource = User.find(user_id)

    mail to: @resource.email,
         subject: "Your Minefold time is low"
  end

  def no_coins(user_id)
    @resource = User.find(user_id)

    mail to: @resource.email,
         subject: "You have run out of Minefold time"
  end

  def receipt(user_id, charge_id, coin_pack_id)
    @resource = User.find(user_id)
    @charge = Stripe::Charge.retrieve(charge_id)
    @coin_pack = CoinPack.find(coin_pack_id)

    mail to: @resource.email,
         subject: "Minefold Receipt #{@charge.id}"
  end

end
