class GiftsController < ApplicationController

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


      render text: 'thanks!'

    end

  end


end
