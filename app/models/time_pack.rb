class TimePack < Struct.new(:amount, :hours)
  def self.all
    [new(595, 20), new(1995, 100), new(7495, 500)]
  end

  def self.find(hours)
    all.find {|p| p.hours == hours}
  end

  def rate
    (amount / hours.to_f).round
  end

  alias_method :cents, :amount

  def dollars
    cents / 100.0
  end
end