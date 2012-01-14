module UserHelper

  def avatar_tag(user, size=20, options={})
    options = {
      alt: user.username,
      width: size,
      height: size
    }.merge(options)

    image_tag user.avatar_url(size), options
  end

end
