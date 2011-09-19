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
      order.transactions.find_or_initialize_by(params)
      order.process_payment!
      order.save

      OrderMailer.thanks(order.id).deliver
    else
      logger.info("[PayPal] Failed to authenticate IPN")
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
