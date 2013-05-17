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

Plan.create(
  stripe_id: 'bronze',
  name: 'Small',
  cents: 1499,
  bolts: 1
)

Plan.create(
  stripe_id: 'silver',
  name: 'Medium',
  cents: 2499,
  bolts: 2
)

Plan.create(
  stripe_id: 'gold',
  name: 'Large',
  cents: 4999,
  bolts: 3
)

# Funpacks

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
  settings_schema: [],
)

Funpack.create(name: 'Bukkit Essentials',
  access_policy_ids: [1,2],
  creator: dave,
  default_access_policy_id: 2,
  description: "A modified version of the Minecraft server.",
  imports: true,
  info_url: "http://bukkit.org",
  maps: true,
  party_cloud_id: '50a976fb7aae5741bb000002',
  persistent: true,
  published_at: Time.now,
  settings_schema: [],
)

Funpack.create(name: 'Team Fortress 2',
  access_policy_ids: [0,3],
  creator: dave,
  default_access_policy_id: 0,
  info_url: 'http://teamfortress.com',
  party_cloud_id: '50bec3967aae5797c0000004',
  published_at: Time.now,
  settings_schema: [],
)

Funpack.create(name: 'Counter Strike: GO',
  creator: chris,
  info_url: 'http://counter-strike.net'
)
