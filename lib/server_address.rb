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
    if server.cname?
      server.cname
    else
      [ server.id,
        "fun-#{server.funpack_id}",
        'us-east-1',
        'foldserver.com'
      ].join('.')
    end
  end

end
