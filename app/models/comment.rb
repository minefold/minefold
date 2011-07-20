class Comment < WallItem
  belongs_to :user
  key :body, String
end