module AnalyticsHelper

  def analytics_id(user)
    user.id.to_s
  end

  def analytics_profile(user)
    base = {
      id: user.id,
      created_at: user.created_at,
      email: user.email,

      username: user.username,
      name: user.name,
      firstName: user.first_name,
      lastName: user.last_name,
      gender: user.gender,

      customer: user.customer?,
      confirmed: user.confirmed?,
      played: user.played?,

      timeLeft: user.coins,
      lastPlayed: user.last_played_at,
      serverCount: user.created_servers.count
    }

    if server = user.created_servers.last
      base.merge!(
        lastServerFunpackSlug: server.funpack.slug,
        lastServerFunpackName: server.funpack.name,
        lastServerName: server.name,
        lastServerAddress: server.address.to_s
      )
    end

    base
  end

end
