class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    if (params[:pack_id] and
        pack = TimePack.find(params[:pack_id]) and
        !params[:stripe_token])

      render(nothing: true, status: :payment_required)
      return
    end

    # Raises Stripe::Stripe error if there was a problem processing the
    # transaction.
    current_user.buy_pack!(params[:stripe_token], pack)

    track 'paid', amount: pack.cents,
                  days: pack.months / 1.day,
                  months: pack.months

    redirect_to user_root_path,
      notice: "Thank you for buying #{pack.months} of Minefold Pro"

  rescue Stripe::StripeError
    render(nothing: true, status: :payment_required)
  end

end
