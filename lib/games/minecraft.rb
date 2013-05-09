require './lib/game'
require './lib/game_access_policy'

class Minecraft < Game

  def auth?
    true
  end

  def split_billing?
    true
  end

  def static_address?
    true
  end

  def maps?
    true
  end

  # TODO Untested
  def account_provider
    Accounts::Mojang
  end

  def default_access_policy
    MinecraftWhitelistAccessPolicy
  end

  def available_access_policies
    [MinecraftBlacklistAccessPolicy, MinecraftWhitelistAccessPolicy]
  end

end
