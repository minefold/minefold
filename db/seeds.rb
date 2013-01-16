# Coin Packs

CoinPack.create(cents: 1_500, coins: 7_500)
CoinPack.create(cents: 3_000, coins: 20_000)
CoinPack.create(cents: 6_000, coins: 60_000)

# Users

chris = User.new(
  username: 'chrislloyd',
  email: 'christopher.lloyd@gmail.com'
)

chris.password, chris.password_confirmation = 'password'
chris.admin = true
chris.skip_confirmation!

chris.save!

dave = User.new(
  username: 'whatupdave',
  email: 'dave@snappyco.de'
)

dave.password, dave.password_confirmation = 'password'
dave.admin = true
dave.skip_confirmation!

dave.save!


# Funpacks

Funpack.create(
  name: 'Minecraft', creator: chris,
  info_url: 'http://minecraft.net',
  party_cloud_id: '50a976ec7aae5741bb000001',
  imports: true
)

Funpack.create(name: 'Bukkit Essentials', creator: chris,
  info_url: "http://bukkit.org",
  description: "Bukkit is a community-based project that works on Minecraft server implementation. This pack includes [Essentials](http://dev.bukkit.org/server-mods/essentials), [WorldEdit](http://dev.bukkit.org/server-mods/worldedit), [WorldGuard](http://dev.bukkit.org/server-mods/worldguard) and [LWC](http://dev.bukkit.org/server-mods/lwc).",
  party_cloud_id: '50a976fb7aae5741bb000002',
  imports: true
)

Funpack.create(name: 'Tekkit', creator: chris,
  info_url: "http://www.technicpack.net/tekkit",
  description: "Tekkit is the multiplayer version of the Technic mod pack. It lets players automate, industrialize and power their worlds.",
  party_cloud_id: '50a977097aae5741bb000003',
  imports: true
)

Funpack.create(
  name: 'Team Fortress 2', creator: chris,
  info_url: 'http://www.teamfortress.com',
  party_cloud_id: '50bec3967aae5797c0000004',
  imports: false
)
