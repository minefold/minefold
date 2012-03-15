# Create MinecraftPlayers out of players

Pivot.db[:users].find({}).each do |user|
  if user["username"]
    puts "Creating player for #{user["username"]}"

    username = user["username"].gsub(/[^\w]/, '')

    player = Pivot.db[:minecraft_players].insert({
      "username" => username,
      "slug" => username.downcase,
      "created_at" => user["created_at"],
      "updated_at" => user["created_at"],
      "user_id" => user["_id"],
      "avatar" => user["avatar"],
      "minutes_played" => user["minutes_played"],
      "last_connected_at" => user["last_connected_at"]
    })
  end

  puts "Cleaning user #{user["_id"]}"

  Pivot.db[:user].update(
    {"_id" => user["_id"]},
    {
      "$unset" => {
        "username" => 1,
        "safe_username" => 1,
        "slug" => 1,
        "avatar" => 1,
        "minutes_played" => 1,
        "last_connected_at" => 1,
        "skin" => 1,
        "special" => 1,
        "host" => 1,
        "last_played_at" => 1
      }
    }
  )
end

Pivot.db[:worlds].find({}).each do |world|
  puts "Updating players for #{world["name"]}"

  # Figure out player lists

  opped_player_ids = [world["creator_id"]]
  whitelisted_player_ids = [world["creator_id"]]

  # Memberships might be blank
  if memberships = world["memberships"]
    memberships.each do |membership|
      player = Pivot.db[:minecraft_players].find_one(
        {"user_id" => membership["user_id"]}
      )

      whitelisted_player_ids |= [player["_id"]]

      if membership["role"] == "op"
        opped_player_ids |= [player["_id"]]
      end
    end
  end


  puts "Updating #{world["name"]}"

  name = world["slug"].gsub(/[^\w]+/, '_').gsub(/^_|_$/,'')

  if name.blank?
    print "#{world["name"]} => "
    name = $stdin.gets
  end

  Pivot.db[:worlds].update(
    {"_id" => world["_id"]},
    {
      "$set" => {
        "opped_player_ids" => opped_player_ids,
        "whitelisted_player_ids" => whitelisted_player_ids,
        "name" => name,
        "legacy_name" => world["name"]
      },
      "$unset" => {
        "memberships" => 1,
        "slug" => 1
      }
    }
  )

end
