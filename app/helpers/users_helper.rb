module UsersHelper

  def link_to_pro(user)
    if signed_in?
      link_to('Pro', pro_account_path, class: 'pro')
    else
      content_tag(:span, 'Pro', class: 'pro')
    end
  end

  def avatar_tag(user_or_player, format=:small, options={})
    player = user_or_player.respond_to?(:avatar) ? user_or_player : user_or_player.minecraft_player
    options = {
      alt: player.username,
    }.merge(options)

    image_tag player.avatar.send(format).url, options
  end

end
