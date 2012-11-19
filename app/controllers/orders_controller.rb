class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout false

  def new
    @credit_packs = CreditPack.active.all.sort_by {|p| p.cents }
  end

  def create
    order = Order.new(
      current_user,
      params[:credit_pack_id],
      params[:stripe_token]
    )

    if order.valid? and order.fulfill
      # Do all our amazing tracking stuff
      track 'paid', 'distinct_id' => order.user.distinct_id,
                    'credit pack' => order.credit_pack.id,
                    'amount'      => order.total

      mixpanel_person_add order.user.distinct_id, 'cents spent' => order.total

      # Send a receipt
      CreditsMailer.receipt(
        order.user.id,
        order.charge_id,
        order.credit_pack.id
      ).deliver

      # TODO Make this redirect to a thank you page.
      redirect_to :back,
        notice: "Thank you for buying Minefold credits"
    else
      render nothing: true, :status => :payment_required
    end
  end

end
