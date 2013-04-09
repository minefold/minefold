require 'transaction_mailer'

class SubscriptionMailer < TransactionMailer
  def receipt(user_id, charge_id)
    @user = User.find(user_id)
    @customer = Stripe::Customer.retrieve(@user.customer_id)
    @card = @customer.active_card
    @subscription = @customer.subscription
    @charge = Stripe::Charge.retrieve(charge_id)

    mail to: @user.email,
         subject: "[Minefold] Payment Receipt"
  end
end
