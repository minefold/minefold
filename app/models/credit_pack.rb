class CreditPack < ActiveRecord::Base

  NORMAL_CREDITS_PER_HOUR = 300
  SHARED_CREDITS_PER_HOUR = 60

  # Stub for when we start experimenting with CreditPack pricing.
  scope :active, limit(4).order("cents ASC")

  def amount
    cents
  end

  def dollars
    cents.to_f / 100
  end

  def cents_per_credit
    cents / credits.to_f
  end

  def normal_hours
    credits / NORMAL_CREDITS_PER_HOUR
  end

  def shared_hours
    credits / SHARED_CREDITS_PER_HOUR
  end

end
