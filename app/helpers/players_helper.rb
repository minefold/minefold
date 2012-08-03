module PlayersHelper

  def link_to_player(player)
    content_tag(:span, class: 'player-username') {
      link_to(player.username, player_path(player), class: 'username') +
      (link_to_pro(player.user) if player.user and player.user.pro?)
    }
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

    options[:class] = ['img', *options[:class]]

    # TODO Hack around shitty Carrierwave
    options[:src] ||= File.join(ENV['ASSET_HOST'], player.avatar.send(options[:size]).path)
    options[:alt] ||= player.username

    content_tag(:div, tag(:img, options), class: 'avatar')
  end

end
