require './lib/game'

class TeamFortress2 < Game

  def default_access_policy
    NoopAccessPolicy
  end

  def available_access_policies
    [NoopAccessPolicy, TeamFortress2PasswordAccessPolicy]
  end

end
