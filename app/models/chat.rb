class Chat < WallItem
  field :raw
  field :html

  def body
    html || raw
  end

  def msg
    "<#{user.username}> #{raw}"
  end

  def as_json(opts={})
    {
      avatar_head_24_url: user.avatar.head.s24.url
    }.merge(super(opts))
  end

end
