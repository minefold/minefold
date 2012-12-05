class CoinPack < ActiveRecord::Base

  NORMAL_COINS_PER_HOUR = 300
  SHARED_COINS_PER_HOUR = 60

  # Stub for when we start experimenting with CoinPack pricing.
  scope :active, limit(3).order("cents ASC")

  def amount
    cents
  end

  def dollars
    cents.to_f / 100
  end

  def cents_per_coin
    cents / coins.to_f
  end

  def normal_hours
    coins / NORMAL_COINS_PER_HOUR
  end

  def shared_hours
    coins / SHARED_COINS_PER_HOUR
  end

  def description
    "Coin Pack ##{id}"
  end

end
