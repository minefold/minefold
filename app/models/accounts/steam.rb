class Accounts::Steam < Account

  def profile_url
    URI::HTTPS.build(
      host: 'steamcommunity.com',
      path: "/profile/#{uid}"
    )
  end

end
