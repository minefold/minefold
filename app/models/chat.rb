class Chat < WallItem
  # Chat.all.map {|c| c.raw = c.body; c.save }
  key :raw, String
  
  key :html, String
  key :media, Array

  after_create do
    Resque.enqueue ProcessChatMessage, id
  end
  
  def process!
    urls = []
    self.html = Rinku.auto_link(raw) {|url| urls << url; url }

    if urls.size > 0
      embedly = Embedly::API.new :key => '739f2006c30d11e089e14040d3dc5c07', :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; admin@minefold.com)'
      self.media = embedly.oembed(urls:urls).map{|m| JSON.parse(m.to_json)['table'] }
    end
    
    save!
    
    push_chat_item
  end
  
  def push_chat_item
    deferrable = wall.channel.trigger!('chat:create', to_hash.to_json)
  end
  
  def send_message_to_world
    # TODO: make sure this was published on a world
    REDIS.publish "world.#{wall.id}.input", "say <#{user.username}> #{raw}"
  end
  
  include ActionView::Helpers::DateHelper
  def to_hash
    {
      id: id,
      user: {
        username: user.username,
        email: user.email,
        gravatar_url: user.gravatar_url(size:36)
      },
      created_ago:time_ago_in_words(created_at),
      body: html || raw,
      media: media
    }
  end
  

end
