class Chat < WallItem
  field :raw
  field :html

  # TODO Should be in WallItem, but there seemed to be an issue with Mongoid.
  belongs_to :user

  def body
    html || raw
  end

  # before_save do
  #   self.html = Rinku.auto_link(raw)
  # end

  def msg
    "<#{user.username}> #{raw}"
  end

  def as_json(opts={})
    {
      avatar_head_24_url: user.avatar.head.s24.url
    }.merge(super(opts))
  end

end
