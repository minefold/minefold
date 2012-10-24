class CreditPack < ActiveRecord::Base
  
  SUPER_CREDITS_PER_HOUR = 60
  NORMAL_CREDITS_PER_HOUR = 300
  
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
  
  def super_hours
    credits / SUPER_CREDITS_PER_HOUR
  end
  
  def normal_hours
    credits / NORMAL_CREDITS_PER_HOUR
  end
  
end
