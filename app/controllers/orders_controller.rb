class OrdersController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  def show
    @order = Order.create!
  end

  def create
    notification = Paypal::Notification.new(request.raw_post)

    order = Order.find(notify.item_id)

    payment = Payment.new_from_params params
    payment.save

    # Verify with PayPal
    # if notification.complete?
    #   begin
    #     if notification.acknowledge
    #       order.receive_payment!(payment)
    #     else
    #       logger
    #     end
    #
    #   rescue StandardError => e
    #     order.fail!
    #   end
    #
    #
    #   begin
    #     if notification.complete?
    #
    #
    # Purchase.create! params: params

    if Rails.env.development?
      redirect_to successful_order_path
    else
      render :nothing
    end
  end

end
