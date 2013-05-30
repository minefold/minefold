class AnalyticsProfile

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def profile
    basics.merge(subscription)
  end

  def basics
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

  def subscription
    if user.active_subscription?
      { plan: user.subscription.plan.stripe_id }
    else
      {}
    end
  end

  def to_json
    profile.to_json
  end

end
