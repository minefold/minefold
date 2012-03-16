module PlayersHelper

  def link_to_player(player, options={})
    content_tag(:span, class: 'username') {
      link_to(player.username, player_path(player), options)
    } + (link_to_pro(player.user) if player.user and player.user.pro?)
  end

  def player_avatar_tag(player, options={})
    case options[:size]
    when :small
      options[:width], options[:height] = [20,20]
    when :medium
      options[:width], options[:height] = [40,40]
    when :large
      options[:width], options[:height] = [60,60]
    end

    options[:src] ||= player.avatar.send(options[:size])
    options[:alrt] ||= player.username

    tag(:img, options)
  end

end
