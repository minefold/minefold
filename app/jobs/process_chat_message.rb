class ProcessChatMessage
  @queue = :high
  
  def self.perform chat_message_id
    Chat.find(chat_message_id).process!
  end
end