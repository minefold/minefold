json.url player_url(player)
json.extract! player, :id, :created_at, :username
json.avatar_url player.avatar.url
