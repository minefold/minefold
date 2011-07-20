class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!, only: [:new, :success, :cancel]

  def new
    @order = Order.create!(user: current_user)
  end

  def create
    order = Order.find params[:custom]

    # TODO: MASSIVE security hole, needs to verify PayPal IPN.
    order.process_payment Payment.new(params: params,
                                      status: params[:payment_status],
                                      txn_id: params[:txn_id])

    order.save

    if Rails.env.development?
      redirect_to successful_order_path
    else
      render :nothing => true
    end
  end

  def success
  end

  def cancel
    redirect_to credits_path
  end

end
