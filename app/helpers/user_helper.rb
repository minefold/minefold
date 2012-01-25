module UserHelper

  def avatar_tag(user, format=:small, options={})
    options = {
      alt: user.username,
    }.merge(options)

    image_tag user.avatar.send(format).url, options
  end

end
