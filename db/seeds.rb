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

# Plans
Plan.create(stripe_id: 'intro-bronze', name: 'Bronze', cents: 1299, bolts: 1)
Plan.create(stripe_id: 'intro-silver', name: 'Silver', cents: 2299, bolts: 2)
Plan.create(stripe_id: 'intro-gold',   name: 'Gold',   cents: 4799, bolts: 3)

# Funpacks

Funpack.create(
  name: 'Minecraft', creator: chris,
  info_url: 'http://minecraft.net',
  party_cloud_id: '50a976ec7aae5741bb000001',
  settings_schema: [],
  imports: true,
  published_at: Time.now
)

Funpack.create(name: 'Bukkit Essentials', creator: chris,
  info_url: "http://bukkit.org",
  description: "Bukkit is a community-based project that works on Minecraft server implementation. This pack includes [Essentials](http://dev.bukkit.org/server-mods/essentials), [WorldEdit](http://dev.bukkit.org/server-mods/worldedit), [WorldGuard](http://dev.bukkit.org/server-mods/worldguard) and [LWC](http://dev.bukkit.org/server-mods/lwc).",
  party_cloud_id: '50a976fb7aae5741bb000002',
  settings_schema: [],
  imports: true,
  published_at: Time.now
)

Funpack.create(name: 'Tekkit', creator: chris,
  info_url: "http://www.technicpack.net/tekkit",
  description: "Tekkit is the multiplayer version of the Technic mod pack. It lets players automate, industrialize and power their worlds.",
  party_cloud_id: '50a977097aae5741bb000003',
  settings_schema: [],
  imports: true,
  published_at: Time.now
)

Funpack.create(name: 'Feed The Beast – Direwolf20', creator: dave,
  info_url: 'http://feed-the-beast.com/',
  party_cloud_id: '512159a67aae57bf17000005',
  settings_schema: [],
  imports: true,
  persistent: true,
  maps: true,
  published_at: Time.now
)

Funpack.create(name: 'Team Fortress 2', creator: chris,
  info_url: 'http://teamfortress.com',
  party_cloud_id: '50bec3967aae5797c0000004',
  settings_schema: [],
  imports: false,
  published_at: Time.now
)

Funpack.create(name: 'Tekkit Lite', creator: dave,
  info_url: "http://www.technicpack.net/tekkit-lite/",
  description: "Tekkit Lite includes most of the mods from Tekkit Classic and adds a load more.",
  party_cloud_id: '5126be367aae5712a4000007',
  settings_schema: [],
  imports: true,
  persistent: true,
  maps: true
)

Funpack.create(name: 'Counter Strike: GO', creator: chris,
  info_url: 'http://counter-strike.net'
)
