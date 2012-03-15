class TimePack < Struct.new(:id, :duration, :cents)
  def self.all
    [ new('beta-3m-1500', 3.months, 1500),
      new('beta-6m-2500', 6.months, 2500),
      new('beta-12m-4500', 12.months, 4500) ]
  end

  def self.find(id)
    all.find {|p| p.id == id}
  end

  def dollars
    cents / 100.0
  end
end
