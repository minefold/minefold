require 'access_policy'

class PublicAccessPolicy < AccessPolicy

  def label
    'all'
  end

end

class MinecraftWhitelistAccessPolicy < AccessPolicy

  def label
    'minecraft-whitelist'
  end

  def data
    (@server.settings['whitelist'] || '').split("\r\n")
  end

end

class MinecraftBlacklistAccessPolicy < AccessPolicy

  def label
    'minecraft-blacklist'
  end

  def data
    (@server.settings['blacklist'] || '').split("\r\n")
  end

end

class TeamFortress2PasswordAccessPolicy < AccessPolicy

  def label
    'tf2-password'
  end

  def data
    @server.settings['sv_password']
  end

end
