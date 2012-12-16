# Coin Packs

CoinPack.create(cents: 1_500, coins: 7_500)
CoinPack.create(cents: 3_000, coins: 20_000)
CoinPack.create(cents: 6_000, coins: 60_000)

# Games

minecraft = Game.create(
  name: 'Minecraft',
  auth: true,
  routing: true,
  maps: true
)

tf2 = Game.new(
  name: 'Team Fortress 2'
)
tf2.slug = 'tf2'
tf2.save!


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

minecraft_default_funpack = Funpack.create(
  name: 'Minecraft', game: minecraft, creator: chris,
  info_url: 'http://minecraft.net',
  party_cloud_id: '50a976ec7aae5741bb000001',
  inports: true
)

minecraft.default_funpack = minecraft_default_funpack
minecraft.save


Funpack.create(name: 'Bukkit Essentials', game: minecraft, creator: chris,
  info_url: "http://bukkit.org",
  description: "Bukkit is a community-based project that works on Minecraft server implementation. This pack includes [Essentials](http://dev.bukkit.org/server-mods/essentials), [WorldEdit](http://dev.bukkit.org/server-mods/worldedit), [WorldGuard](http://dev.bukkit.org/server-mods/worldguard) and [LWC](http://dev.bukkit.org/server-mods/lwc).",
  party_cloud_id: '50a976fb7aae5741bb000002',
  inputs: true
)

Funpack.create(name: 'Tekkit', game: minecraft, creator: chris,
  info_url: "http://www.technicpack.net/tekkit",
  description: "Tekkit is the multiplayer version of the Technic mod pack. It lets players automate, industrialize and power their worlds.",
  party_cloud_id: '50a977097aae5741bb000003',
  inports: true
)


tf2_default_funpack = Funpack.create(
  name: 'Team Fortress 2', game: tf2, creator: chris,
  info_url: 'http://www.teamfortress.com',
  inports: false
)

tf2.default_funpack = tf2_default_funpack
tf2.save


