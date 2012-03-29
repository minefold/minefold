# Create MinecraftPlayers out of players

Pivot.db[:users].find({}).each do |user|
  if user["username"]
    puts "Creating player for #{user["_id"]} #{user["username"]}"

    username = user["username"].gsub(/[^\w]/, '')

    player = Pivot.db[:minecraft_players].find_and_modify(
    query: {
      "username" => username,
    },
    update: {
      "username" => username,
      "slug" => username.downcase,
      "created_at" => user["created_at"],
      "updated_at" => user["created_at"],
      "user_id" => user["_id"],
      "avatar" => user["avatar"],
      "minutes_played" => user["minutes_played"],
      "last_connected_at" => user["last_connected_at"]
    }, upsert: true, new: true)
    
    puts "Created player #{player["_id"]} #{player["username"]}"
  end
end

Pivot.db[:worlds].find({}).each do |world|
  puts "Updating players for #{world["_id"]} #{world["name"]}"

  # make sure creator exists
  creator = Pivot.db[:users].find_one(_id: world['creator_id'])
  unless creator
    puts "No creator, removing world"
    Pivot.db[:worlds].remove(_id: world['creator_id'])
  else
    creator_player = Pivot.db[:minecraft_players].find_one(slug: creator["username"].gsub(/[^\w]/, '').downcase)
    raise "no player for creator" unless creator_player

    # Figure out player lists

    opped_player_ids = [creator_player["_id"]]
    whitelisted_player_ids = [creator_player["_id"]]

    # Memberships might be blank
    if memberships = world["memberships"]
      puts "#{world['name']} #{memberships.size}"
      memberships.each do |membership|
        player = Pivot.db[:minecraft_players].find_one(
          {"user_id" => membership["user_id"]}
        )

        if player
          whitelisted_player_ids |= [player["_id"]]

          if membership["role"] == "op"
            opped_player_ids |= [player["_id"]]
          end
        end
      end
    end


    puts "Updating #{world["name"]}"

    slug = world["slug"].gsub(/[^\w]+/, '_').gsub(/^_|_$/,'')

    short_names = {
      '.' => 'dot',
      '?' => 'question',
      '?!' => 'what',
      ':)' => 'smile',
      '[' => 'bracket'
    }

    if slug.blank?
      slug = short_names[world["name"]]
    end

    if slug.blank?
      print "#{world["name"]} => "
      slug = $stdin.gets
    end

    Pivot.db[:worlds].update(
      {"_id" => world["_id"]},
      {
        "$set" => {
          "opped_player_ids" => opped_player_ids,
          "whitelisted_player_ids" => whitelisted_player_ids,
          "slug" => slug,
          "legacy_name" => world["name"]
        },
        "$unset" => {
          "memberships" => 1
        }
      }
    )
  end
end

# clean users
puts "Cleaning users"
Pivot.db[:user].update(
  {},
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

