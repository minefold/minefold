class ServerAddress

  attr_reader :server

  def initialize(server)
    @server = server
  end

  def to_s
    if server.static_address?
      address
    else
      ip
    end
  end

  def ip
    [server.host, server.port].compact.join(':')
  end

  def address
    if custom?
      custom
    else
      default
    end
  end

# private

  def custom?
    server.cname? and !(server.cname =~ /(foldserver|minefold)\.com$/)
  end

  def custom
    server.cname
  end

  def default
    [ server.id,
      "fun-#{server.funpack_id}",
      'us-east-1',
      'foldserver.com'
    ].join('.')
  end

end
