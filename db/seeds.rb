# Credit Packs

CreditPack.create(cents: 1_500, credits: 7_500)
CreditPack.create(cents: 3_000, credits: 18_000)
CreditPack.create(cents: 6_000, credits: 45_000)
CreditPack.create(cents: 12_000, credits: 120_000)


# Freebies

Reward.create(name: 'facebook linked', credits: 200)
Reward.create(name: 'minecraft linked', credits: 400)


# Games

minecraft = Game.create(
  name: 'Minecraft',
  super_servers: true,
  persistant_data: true
)


# Users

chris = User.new(
  username: 'chrislloyd',
  email: 'christopher.lloyd@gmail.com'
)

chris.password, chris.password_confirmation = 'password'
chris.admin = true
chris.players.new(game: minecraft, uid: 'chrislloyd')
chris.skip_confirmation!

chris.save!

dave = User.new(
  username: 'whatupdave',
  email: 'dave@snappyco.de'
)

dave.password, dave.password_confirmation = 'password'
dave.admin = true
dave.players.new(game: minecraft, uid: 'whatupdave')
dave.skip_confirmation!

dave.save!


# Funpacks

Funpack.create(name: 'Official', game: minecraft, creator: chris)
Funpack.create(name: 'Bukkit', game: minecraft, creator: chris)
Funpack.create(name: 'Tekkit', game: minecraft, creator: chris)
