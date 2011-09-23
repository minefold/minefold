class Chat < WallItem
  field :raw
  field :html

  field :media, type: Array

  # TODO Should be in WallItem, but there seemed to be an issue with Mongoid.
  belongs_to :user

  def body
    html || raw
  end

  # after_create do
  #   Resque.enqueue ProcessChatJob, [wall.id, id]
  # end

  before_save do
    self.html = Rinku.auto_link(raw)
  end

  # def broadcase_chat_item
  #   wall.broadcast 'chat-create', to_json(include: :user)
  # end

  def msg
    "<#{user.username}> #{raw}"
  end

  # def send_message_to_world
  #   wall.say msg
  # end

end
