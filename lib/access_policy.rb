class AccessPolicy

  attr_reader :server

  def initialize(server)
    @server = server
  end

  def label
  end

  def data
  end

  def to_hash
    { name: label, data: data }
  end

  def private?
    not public?
  end

end
