class Chat < WallItem
  key :msg, String

  after_create do
    deferrable = wall.channel.trigger_async('chat:create', {
      user: {
        username: user.username,
        email: user.email,
        gravatar_url: user.gravatar_url
      },
      body: body
    }.to_json)

    # TODO: Better error logging
    deferrable.callback do
      puts 'success'
    end

    deferrable.errback do |err|
      puts err
    end
  end

end
