class GiftsController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, only: [:redeem, :redeem_action]

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

  def redeem_action
    @gift = Gift.find_by_token!(params[:token])

    @gift.child = current_user
    current_user.increment_coins! @gift.coin_pack.coins
    @gift.save

    flash[:notice] = "You've successfully redeemed your gift certificate!"

    redirect_to user_root_path
  end

  def cheers
  end

  def certificate
    render layout: false
  end

end
