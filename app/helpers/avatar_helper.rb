module AvatarHelper

  def small_avatar(user)
    image_tag(user.avatar.small.url, width: 20, height: 20, class: 'avatar')
  end

  def medium_avatar(user)
    image_tag(user.avatar.medium.url, width: 40, height: 40, class: 'avatar')
  end

  def large_avatar(user)
    image_tag(user.avatar.large.url, width: 60, height: 60, class: 'avatar')
  end

end
