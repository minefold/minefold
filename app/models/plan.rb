class Plan < Struct.new(:name, :stripe_id, :hours, :worlds)
  def self.free
    Plan.new('Free', 'free', 4, 1)
  end
  
  def self.casual
    Plan.new('Casual', 'casual', 40, 5)
  end

  def self.hardcore
    Plan.new('Hardcore', 'hardcore', 80, 10)
  end
  
  def self.pro
    Plan.new('Pro', 'pro', 160, 40)
  end
  
  def self.all
    [free, casual, hardcore, pro]
  end
  
  def self.stripe_ids
    all.map(&:stripe_id)
  end
  
  DEFAULT = free
  
  def credits
    hours.hours / User::BILLING_PERIOD
  end
  
end

