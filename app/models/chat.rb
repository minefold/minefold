class Chat < WallItem
  key :msg, String

  after_create do
    deferrable = wall.channel.trigger_async('chat:create', {
      user: {
        username: user.username,
        email: user.email,
        gravatar_url: user.gravatar_url
      },
      msg: msg
    }.to_json)

    deferrable.callback do
      puts 'success'
      # logger.info 'msg sent'
    end

    deferrable.errback do |err|
      puts err
      # logger.error 'msg not send'
      # logger.error(err)
    end
  end

end
