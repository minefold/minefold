class Plan < Struct.new(:id, :stripe_id, :name, :price, :hours)
  def self.all
    [free, small, medium, large]
  end
  
  def self.free
    Plan.new('casual', nil, 'Casual', 0, 4)
  end
  
  def self.small
    Plan.new('small', 'small', 'Small', 395, 40)
  end
  
  def self.medium
    Plan.new('medium', 'medium', 'Medium', 995, 100)
  end
  
  def self.large
    Plan.new('large', 'large', 'Large', 1995, 260)
  end
  
  def self.find id
    all.find{|p| p.id == id}
  end

  def self.find_by_stripe_id stripe_id
    all.find{|p| p.stripe_id == stripe_id}
  end
  
  def self.stripe_ids
    all.map(&:stripe_id)
  end
  
  def credits
    hours * 60
  end
end