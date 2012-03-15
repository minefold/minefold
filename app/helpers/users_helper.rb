module UsersHelper

  def link_to_pro(user)
    if signed_in?
      link_to('Pro', pro_account_path, class: 'pro')
    else
      content_tag(:span, 'Pro', class: 'pro')
    end
  end

  def avatar_tag(user, format=:small, options={})
    options = {
      alt: user.username,
    }.merge(options)

    image_tag user.minecraft_player.avatar.send(format).url, options
  end

end
