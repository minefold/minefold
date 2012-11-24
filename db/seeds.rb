# Credit Packs

CreditPack.create(cents: 1_500, credits: 7_500)
CreditPack.create(cents: 3_000, credits: 18_000)
CreditPack.create(cents: 6_000, credits: 45_000)
CreditPack.create(cents: 12_000, credits: 120_000)

# Games

minecraft = Game.create(
  name: 'Minecraft',
  shared_servers: true,
  persistant: true
)


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
  name: 'Official', game: minecraft, creator: chris,
  info_url: 'http://minecraft.net',
  description: "Vanilla Minecraft, the way Notch intended!",
  party_cloud_id: '50a976ec7aae5741bb000001')

Funpack.create(name: 'Bukkit Essentials', game: minecraft, creator: chris,
  info_url: "http://bukkit.org",
  description: "Bukkit is a community-based project that works on Minecraft server implementation. This pack includes [Essentials](http://dev.bukkit.org/server-mods/essentials), [WorldEdit](http://dev.bukkit.org/server-mods/worldedit), [WorldGuard](http://dev.bukkit.org/server-mods/worldguard) and [LWC](http://dev.bukkit.org/server-mods/lwc).",
  party_cloud_id: '50a976fb7aae5741bb000002')

Funpack.create(name: 'Tekkit', game: minecraft, creator: chris,
  info_url: "http://www.technicpack.net/tekkit",
  description: "Tekkit is the multiplayer version of the Technic mod pack. It lets players automate, industrialize and power their worlds.",
  party_cloud_id: '50a977097aae5741bb000003')
