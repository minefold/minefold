class Product < Struct.new(:price, :hours)
  def self.all
    [new(295, 10), new(795, 40), new(1995, 200)]
  end

  def self.find(hours)
    all.find {|p| p.hours == hours}
  end

  def rate
    (price / hours).round(-1)
  end

  alias_method :cents, :price

  def dollars
    price / 100.0
  end

end