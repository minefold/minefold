class AnalyticsProfile

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def profile
    { created: user.created_at,
      email: user.email,

      username: user.username,
      name: user.name,
      firstName: user.first_name,
      lastName: user.last_name,
      gender: user.gender,

      customer: user.customer?,
      confirmed: user.confirmed?,
      played: user.played?,

      trialTimeLeft: user.coins
    }
  end

  def to_json
    profile.to_json
  end

end
