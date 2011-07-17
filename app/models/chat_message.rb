class ChatMessage < WallItem
  belongs_to :user
  key :username, String
  key :message, String
end