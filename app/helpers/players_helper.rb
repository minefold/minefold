module PlayersHelper

  def link_to_player(player, options={})
    content_tag(:span, class: 'username') {
      link_to(player.username, player_path(player), options)
    } + (link_to_pro(player.user) if player.user and player.user.pro?)
  end

end
