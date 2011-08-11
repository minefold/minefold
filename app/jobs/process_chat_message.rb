class ProcessChatMessage
  @queue = :high
  
  def self.perform chat_message_id
    chat = Chat.find chat_message_id
    
    chat.process!
    chat.push_chat_item
    chat.send_message_to_world
  end
  
end