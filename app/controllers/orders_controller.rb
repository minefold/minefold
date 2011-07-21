class OrdersController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  prepend_before_filter :authenticate_user!, except: [:create]

  def new
    @order = Order.create!(user: current_user)
  end

  def create
    notify = Paypal::Notification.new(request.raw_post)
    order = Order.find(notify.item_id)

    if notify.acknowledge
      payment = order.payments.find {|p| p.txn_id == notify.transaction_id}

      if payment.nil?
        payment = Payment.new(params: params[params],
                              txn_id: notify.transaction_id)
        order.payments << payment
      end

      begin
        if notify.complete?
          payment.status = notify.status
        else
          logger.error("Failed to verify Paypal's notification, please investigate")
        end
      rescue => e
        payment.status = 'Error'
        raise
      ensure
        order.save
      end
    end
  end

  def success
  end

  def cancel
    redirect_to credits_path
  end

end
