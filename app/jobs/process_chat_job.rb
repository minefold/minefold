class ProcessChatJob
  @queue = :high

  def self.perform chat_id
    new.process! Chat.find(chat_id)
  end

# private

  # TODO Extract Embedly API key to ENV var
  def self.embedly
    @embedly ||= Embedly::API.new key: '739f2006c30d11e089e14040d3dc5c07',
                           user_agent: 'Mozilla/5.0 (compatible; minefold/1.0; team@minefold.com)'
  end

  def process! chat
    urls = []
    chat.html = Rinku.auto_link(chat.raw) {|url| urls << url; url }

    if !urls.empty?
      chat.media = self.class.embedly.oembed(urls: urls).map do |raw|
        JSON.parse(raw.to_json)['table']
      end
    end

    chat.save!
  end

end
