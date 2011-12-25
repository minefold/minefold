# Move from whitelisted players to world memberships

world_players = World.collection.find.each_with_object({}) do |w, h| 
  h[w['_id']] = (w['whitelisted_player_ids'] || [])
end

world_players.each do |world_id, player_ids|
  w = World.find(world_id)
  player_ids.each do |player_id|
    w.memberships << Membership.new(user_id: player_id, role: 'player')
  end
  puts "world: #{w.name}  members: #{w.memberships.size}"
end