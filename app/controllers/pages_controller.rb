class PagesController < ApplicationController

  prepend_before_filter :authenticate_user!, only: [:welcome, :time]

  def about
  end

  def developers
  end

  def time
    @small_coin_pack = CoinPack.active.first
  end

  def support
  end

  def home
    @funpacks = Funpack.order(:published_at, :name).limit(6)
  end

  def plans
    @plans = Plan.all
    @funpacks = Funpack.published.order('name').all
    @tradein_coins = 0
    @current_discount = 0

    if signed_in?
      if current_user.coins >= (40 * 60)
        @tradein_coins = current_user.coins
      end
      if subscription = current_user.subscription
        @current_discount = subscription.discount
      end
    end

    @tradein = @tradein_coins > 0
    @tradein_discount = [5, @tradein_coins / 40 / 60].min

    @on_sale = @tradein || @current_discount > 0
  end

  def privacy
  end

  def terms
  end

end
