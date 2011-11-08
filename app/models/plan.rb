class Plan < Struct.new(:id, :name, :price, :hours)
  def self.all
    [free, small, medium, large]
  end
  
  def self.free
    Plan.new(nil, 'Free', 0, 4)
  end
  
  def self.small
    Plan.new('small', 'Small', 395, 40)
  end
  
  def self.medium
    Plan.new('medium', 'Medium', 795, 80)
  end
  
  def self.large
    Plan.new('large', 'Large', 1195, 160)
  end
  
  def self.find id
    all.find{|p| p.id == id}
  end
  
  def credits
    hours * 60
  end
end