class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!, except: [:create]

  PRICES = {
    8   => 400,
    20  => 800,
    60  => 1800,
    160 => 4000
  }

  def new
    @order = Order.new
  end

  def create
    # TODO Error checking

    unless current_user.customer_id?
      token = params[:stripeToken]

      customer = Stripe::Customer.create card: token,
                                  description: current_user.username,
                                        email: current_user.email

      current_user.customer_id = customer.id
      current_user.save
    end

    amount = PRICES[params[:hours].to_i]

    Stripe::Charge.create amount: amount,
                        currency: 'usd',
                        customer: current_user.customer_id

    credits = params[:hours].to_i.hours / User::BILLING_PERIOD

    current_user.increment_credits! credits

    redirect_to user_root_path
  end

  # def success
  # end
  #
  # def cancel
  #   redirect_to new_order_path
  # end

protected

  # statsd_count_success :new, 'OrdersController.new'
  # statsd_count_success :create, 'OrdersController.create'
  # statsd_count_success :success, 'OrdersController.success'
  # statsd_count_success :cancel, 'OrdersController.cancel'

end
