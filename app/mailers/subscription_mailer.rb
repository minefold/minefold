require 'transaction_mailer'

class SubscriptionMailer < TransactionMailer

  def receipt(user_id, subscription_id, plan_id)
    @user = User.find(user_id)
    @customer = Stripe::Customer.retrieve(@user.customer_id)
    @card = @customer.active_card
    @subscription = @customer.subscription
    @plan = Plan.find(plan_id)

    mail to: @user.email,
         subject: "[Minefold] Payment Receipt"
  end

end
