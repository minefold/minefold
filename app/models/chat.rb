class Chat < WallItem
  key :raw, String

  key :html, String
  key :media, Array

  after_create do
    Resque.enqueue ProcessChatMessage, id
  end

  def process!
    urls = []
    self.html = Rinku.auto_link(raw) {|url| urls << url; url }

    unless urls.empty?
      # TODO: Move to env var
      embedly = Embedly::API.new key: '739f2006c30d11e089e14040d3dc5c07',
                          user_agent: 'Mozilla/5.0 (compatible; mytestapp/1.0; admin@minefold.com)'

      self.media = embedly.oembed(urls: urls).map do |raw|
        JSON.parse(raw.to_json)['table']
      end
    end

    save!

    push_chat_item
  end

  def push_chat_item
    deferrable = wall.channel.trigger!('chat:create', to_hash.to_json)
  end

  # TODO: make sure this was published on a world
  def send_message_to_world
    cmd "say <#{user.username}> #{raw}"
  end

  include ActionView::Helpers::DateHelper
  # TODO: Investigate presenter classes
  def to_hash
    { id: id,
      user: {
        username: user.username,
        email: user.email,
        # TODO: Do this clientside
        gravatar_url: user.gravatar_url(size:36)
      },
      created_ago:time_ago_in_words(created_at),
      body: html || raw,
      media: media
    }
  end

private

  def cmd(str)
    REDIS.publish "world.#{world.id}.input", str
  end

end
