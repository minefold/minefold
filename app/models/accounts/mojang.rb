class Accounts::Mojang < Account

  def username
    uid
  end

  def avatar_url(size = 60)
    URI::HTTPS.build(host: "d3811j97z0k4bc.cloudfront.net",
      path: "/helm/#{uid}/#{size}.png"
    )
  end

end
