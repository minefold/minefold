# Move from whitelisted players to world memberships

world_players = World.collection.find.each_with_object({}) do |w, h| 
  h[w['_id']] = (w['whitelisted_player_ids'] || [])
end

world_players.each do |world_id, player_ids|
  w = World.find(world_id)
  w.memberships.destroy_all
  w.memberships << Membership.new(user: w.creator, role: 'op')
  player_ids.uniq.each do |player_id|
    if User.where('_id' => player_id).any?
      w.memberships << Membership.new(user_id: player_id, role: 'player')
    end
  end
  puts "world: #{w.name}  members: #{w.memberships.size}"
end