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
micro  = Plan.create(stripe_id: 'micro',  name: 'Micro',  cents: 499,  bolts: 1)
bronze = Plan.create(stripe_id: 'bronze', name: 'Bronze', cents: 1499, bolts: 1)
silver = Plan.create(stripe_id: 'silver', name: 'Silver', cents: 2499, bolts: 2)
gold   = Plan.create(stripe_id: 'gold',   name: 'Gold',   cents: 4999, bolts: 3)

# allocations
mc_allocations = [
  { plan: micro,  ram: 512,  players: 3 },
  { plan: bronze, ram: 512,  players: 10 },
  { plan: silver, ram: 1024, players: 25 },
  { plan: gold,   ram: 2048, players: 50 },
]

mc_plugin_allocations = [
  { plan: bronze, ram: 512,  players: 10 },
  { plan: silver, ram: 1024, players: 25 },
  { plan: gold,   ram: 2048, players: 50 },
]

tf2_allocations = [
  { plan: micro,  ram: 512,  players: 4 },
  { plan: bronze, ram: 512,  players: 24 },
  { plan: silver, ram: 1024, players: 32 },
  { plan: gold,   ram: 1024, players: 32 },
]

# Funpacks
Funpack.create(name: 'Team Fortress 2', creator: chris,
  info_url: 'http://teamfortress.com',
  party_cloud_id: '50bec3967aae5797c0000004',
  settings_schema: [],
  imports: false,
  published_at: Time.now
).tap {|fp|
  tf2_allocations.each do |a|
    fp.plan_allocations.create(a)
  end
}

Funpack.create(
  access_policy_ids: [1,2],
  creator: chris,
  default_access_policy_id: 2,
  imports: true,
  info_url: 'http://minecraft.net',
  maps: true,
  name: 'Minecraft',
  party_cloud_id: '50a976ec7aae5741bb000001',
  persistent: true,
  published_at: Time.now,
  settings_schema: []
).tap{|fp|
  mc_allocations.each do |a|
    fp.plan_allocations.create(a)
  end
}

Funpack.create(name: 'Bukkit Essentials',
  access_policy_ids: [1,2],
  creator: dave,
  default_access_policy_id: 2,
  description: "A modified version of the Minecraft server.",
  imports: true,
  info_url: "http://bukkit.org",
  maps: true,
  party_cloud_id: '50a976fb7aae5741bb000002',
  settings_schema: [],
  published_at: Time.now
).tap{|fp|
  mc_plugin_allocations.each do |a|
    fp.plan_allocations.create(a)
  end
}

Funpack.create(name: 'Tekkit', creator: chris,
  info_url: "http://www.technicpack.net/tekkit",
  description: "Tekkit is the multiplayer version of the Technic mod pack. It lets players automate, industrialize and power their worlds.",
  party_cloud_id: '50a977097aae5741bb000003',
  settings_schema: [],
  imports: true,
  published_at: Time.now
).tap{|fp|
  mc_plugin_allocations.each do |a|
    fp.plan_allocations.create(a)
  end
}

Funpack.create(name: 'Feed The Beast – Direwolf20', creator: dave,
  info_url: 'http://feed-the-beast.com/',
  party_cloud_id: '512159a67aae57bf17000005',
  settings_schema: [],
  imports: true,
  persistent: true,
  maps: true,
  published_at: Time.now
).tap{|fp|
  mc_plugin_allocations.each do |a|
    fp.plan_allocations.create(a)
  end
}

Funpack.create(name: 'Tekkit Lite', creator: dave,
  info_url: "http://www.technicpack.net/tekkit-lite/",
  description: "Tekkit Lite includes most of the mods from Tekkit Classic and adds a load more.",
  party_cloud_id: '5126be367aae5712a4000007',
  settings_schema: [],
  imports: true,
  persistent: true,
  maps: true
).tap{|fp|
  mc_plugin_allocations.each do |a|
    fp.plan_allocations.create(a)
  end
}

Funpack.create(name: 'Counter Strike: GO',
  creator: chris,
  info_url: 'http://counter-strike.net'
)
