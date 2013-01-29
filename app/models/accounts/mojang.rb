class Accounts::Mojang < Account

  def username
    uid
  end

  def avatar_url(size = 60)
    URI::HTTPS.build(host: "minotar.net",
      path: "/helm/#{uid}/#{size}.png"
    )
  end

end
