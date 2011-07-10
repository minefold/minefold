class OrdersController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  def new
    @order = Order.create!(user: user)
  end

  def create
    notification = Paypal::Notification.new(request.raw_post)

    order = Order.find(params[:custom])

    payment = Payment.create params: params,
                             status: params[:payment_status],
                             txn_id: params[:txn_id],
                              order: order

    # TODO: MASSIVE security hole, needs to verify PayPal IPN.
    if payment.complete?
      order.receive_payment!(payment)
    end

    if Rails.env.development?
      redirect_to successful_order_path
    else
      render :nothing
    end
  end

  def success
  end

  def cancel
  end

end
