class Comment < WallItem
  belongs_to :user
  key :body, String, required: true
end
