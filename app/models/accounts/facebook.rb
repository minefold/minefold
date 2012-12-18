class Accounts::Facebook < Account

  EXTRA_ATTRS = [
    :username,
    :email,
    :first_name,
    :last_name,
    :name,
    :locale,
    :timezone,
    :gender
  ]

  def self.extract_attrs(attrs)
    { username: attrs['username'],
      email: attrs['email'],
      first_name: attrs['first_name'],
      last_name:  attrs['last_name'],
      name: attrs['name'],
      locale: attrs['locale'],
      timezone: attrs['timezone'],
      gender: attrs['gender']
    }
  end

  def username
    user.name.present? ? user.name : uid
  end

  def profile_url
    URI::HTTPS.build(
      host: 'facebook.com',
      path: "/#{uid}"
    )
  end

  def avatar_url
    URI::HTTPS.build(
      host: "graph.facebook.com",
      path: "/#{uid}/picture",
      query: "return_ssl_resources=1&type=square"
    )
  end

end
