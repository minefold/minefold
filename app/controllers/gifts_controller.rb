class GiftsController < ApplicationController
  respond_to :html

  expose(:gift)

  def index
    @packs = CoinPack.active.all
  end

  def create
    if signed_in?
      gift.parent = current_user
      gift.customer_id = current_user.customer_id
    end

    if gift.valid? and gift.fulfill && gift.save

      GiftsMailer.receipt(gift.id).deliver

      track 'Purchased', 'gift' => gift.id,
                         'existing customer' => gift.parent_id

      respond_with(gift, location: xmas_cheers_path(gift))
    else
      flash[:error] = "There was an error charing your card. Please try another card or contact support."

      redirect_to xmas_promo_path
    end

  end

  def pooper
  end

  def redeem
  end

  def cheers
  end

  def certificate
    render layout: false
  end

end
