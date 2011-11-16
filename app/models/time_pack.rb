class TimePack < Struct.new(:hours, :price)
  def self.all
    [new(10, 295), new(40, 795), new(200, 1995)]
  end
  
  def self.find hours
    all.find{|p| p.hours == hours}
  end
end