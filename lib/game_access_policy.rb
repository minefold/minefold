class GameAccessPolicy

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

end

class PublicAccessPolicy < GameAccessPolicy

  def label
    'all'
  end

end

class MinecraftWhitelistAccessPolicy < GameAccessPolicy

  def label
    'minecraft-whitelist'
  end

  def data
    @server.settings['whitelist'].split("\r\n")
  end

end

class MinecraftBlacklistAccessPolicy < GameAccessPolicy

  def label
    'minecraft-blacklist'
  end

  def data
    @server.settings['blacklist'].split("\r\n")
  end

end

class TeamFortress2PasswordAccessPolicy < GameAccessPolicy

  def label
    'tf2-password'
  end

  def data
    @server.settings['sv_password']
  end

end
