class ServerAuth

  attr_reader :server

  def initialize(server)
    @server = server
  end

  def setup?
    false
  end

  def setup
  end

  def persist?
    false
  end

  def persist
  end

  def can_play?(user)
    true
  end

end
