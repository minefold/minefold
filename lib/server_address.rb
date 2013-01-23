class ServerAddress

  attr_reader :server

  def initialize(server)
    @server = server
  end

  def to_s
    if server.game.static_addresses?
      address
    else
      ip
    end
  end

# private

  def ip
    [server.host, server.port].compact.join(':')
  end

  def address
    if server.host?
      ip
    else
      "1.fun-1.us-east-1.foldserver.com"
    end
  end

end
