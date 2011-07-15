class Post < WallItem
  belongs_to :user
  key :message, String
end