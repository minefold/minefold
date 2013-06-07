require 'transaction_mailer'

class SubscriptionMailer < TransactionMailer
  def receipt(user_id, charge_id)
    @user = User.find(user_id)
    @customer = Stripe::Customer.retrieve(@user.customer_id)
    @card = @customer.active_card
    @subscription = @customer.subscription
    @charge = Stripe::Charge.retrieve(charge_id)

    tag 'subscription#receipt'
    mail to: @user.email,
         subject: "[Minefold] Payment Receipt"
  end

  def payment_failed(user_id, invoice_id)
    @user = User.find(user_id)
    @customer = Stripe::Customer.retrieve(@user.customer_id)
    @card = @customer.active_card
    @subscription = @customer.subscription
    @invoice = Stripe::Charge.retrieve(invoice_id)

    tag 'subscription#failed'
    mail to: @user.email,
         subject: "[Minefold] We had a problem billing your credit card"
  end

  def payment_failed_permanently(user_id, invoice_id)
    @user = User.find(user_id)
    @customer = Stripe::Customer.retrieve(@user.customer_id)
    @card = @customer.active_card
    @subscription = @customer.subscription
    @invoice = Stripe::Charge.retrieve(invoice_id)

    tag 'subscription#failed'
    mail to: @user.email,
         subject: "[Minefold] We've cancelled your subscription"
  end
end
