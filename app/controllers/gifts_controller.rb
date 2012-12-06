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

    gift.valid? and gift.fulfill && gift.save

    GiftsMailer.receipt(gift.id).deliver

    respond_with(gift, location: xmas_cheers_path(gift))
  end

  def cheers
  end

end
