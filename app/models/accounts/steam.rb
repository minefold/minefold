class Accounts::Steam < Account

  def username
    user.name.present? ? user.name : uid
  end

  # def profile_url
  #   URI::HTTPS.build(
  #     host: 'facebook.com',
  #     path: "/#{uid}"
  #   )
  # end
  #
  # def avatar_url
  #   URI::HTTPS.build(
  #     host: "graph.facebook.com",
  #     path: "/#{uid}/picture",
  #     query: "return_ssl_resources=1&type=square"
  #   )
  # end

end
