class Plan < Struct.new(:name, :stripe_id, :cost, :hours, :worlds)
  def self.free
    Plan.new('Free', 'free', 0, 4, 1)
  end
  
  def self.casual
    Plan.new('Casual', 'casual', 3.95, 40, 5)
  end

  def self.hardcore
    Plan.new('Hardcore', 'hardcore', 7.95, 80, 10)
  end
  
  def self.pro
    Plan.new('Pro', 'pro', 11.95, 160, 40)
  end
  
  def self.all
    [free, casual, hardcore, pro]
  end
  
  def self.stripe_ids
    all.map(&:stripe_id)
  end
  
  def self.find stripe_id
    all.find{|p| p.stripe_id == stripe_id}
  end
  
  DEFAULT = free
  
  def credits
    hours.hours / User::BILLING_PERIOD
  end
  
  def free?
    cost == 0
  end
  
end

