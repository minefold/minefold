class ProcessChatJob
  @queue = :high

  def self.perform chat_id
    new.process! Chat.find(chat_id)
  end

# private

  def process! chat
    urls = []
    chat.html = Rinku.auto_link(chat.raw) {|url| urls << url; url }
    chat.save!
  end

end
