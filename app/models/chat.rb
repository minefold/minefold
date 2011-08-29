class Chat < WallItem
  field :raw
  field :html

  field :media, type: Array

  def body
    html || raw
  end

# TODO: Enqueue Job

#   after_create do
#     Resque.enqueue ProcessChatMessage, id
#   end
#
#   def push_chat_item
#     deferrable = wall.channel.trigger!('chat:create', to_hash.to_json)
#   end
#
#   # TODO: make sure this was published on a world
#   def send_message_to_world
#     cmd "say <#{user.username}> #{raw}"
#   end
#
#   # TODO: Investigate presenter classes
#   def to_hash
#     { id: id,
#       user: {
#         username: user.username,
#         email: user.email,
#         # TODO: Move to client
#         gravatar_url: user.gravatar_url(size:36)
#       },
#       created_ago: created_ago,
#       body: body,
#       media: media
#     }
#   end
#
#   include ActionView::Helpers::DateHelper
#
#   # TODO: Move to client
#   def created_ago
#     time_ago_in_words(created_at)
#   end

end
