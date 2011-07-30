class Chat < WallItem
  key :msg, String

  after_create do
    push_chat_item
    send_message_to_world
  end
  
  protected
  
  def push_chat_item
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
  
  def send_message_to_world
    # TODO: make sure this was published on a world
    REDIS.publish "world.#{wall.id}.input", "say [WEB] <#{user.username}> #{body}"
  end
  

end
