class OrdersController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  prepend_before_filter :authenticate_user!, except: [:create]

  def new
    @order = Order.create!(user: current_user)
  end



  def create
    notify = Paypal::Notification.new(request.raw_post)
    order = Order.find(params[:custom])

    if notify.acknowledge
      payment = order.payments.find(notify.transaction_id)

      if payment.nil?
        payment = Payment.new(id: notify.transaction_id,
                          params: params)

        order.payments << payment
      end

      begin
        if notify.complete?
          payment.status = notify.status
          order.process_payment(payment)
          logger.info("Processed PayPal IPN")
        else
          logger.error("Failed to verify Paypal's notification, please investigate")
        end
      rescue => e
        payment.status = 'Error'
        raise
      ensure
        order.save
      end
    else
      logger.info("Failed to authenticate PayPal IPN")
    end

    render nothing: true
  end

  def success
  end

  def cancel
    redirect_to credits_path
  end

protected

  statsd_count_success :new, 'OrdersController.new'
  statsd_count_success :create, 'OrdersController.create'
  statsd_count_success :success, 'OrdersController.success'
  statsd_count_success :cancel, 'OrdersController.cancel'

end
