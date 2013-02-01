require 'transaction_mailer'

class OrderMailer < TransactionMailer

  def receipt(user_id, charge_id, coin_pack_id)
    @user = User.find(user_id)
    @charge = Stripe::Charge.retrieve(charge_id)
    @coin_pack = CoinPack.find(coin_pack_id)

    mail to: @user.email,
         subject: "Minefold Receipt #{@charge.id}"
  end

end
