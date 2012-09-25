# Credit Packs

# three_months = CreditPack.create(cents: 1_500, cr: 7_500)
# six_months   = CreditPack.create(cents: 3_000, cr: 15_000)
# one_year     = CreditPack.create(cents: 4_500, cr: 22_500)

{
# $      => credits
  1_500  => 7_500,
  3_000  => 18_000,
  6_000  => 45_000,
  12_000 => 120_000
}.each do |cents, credits|
  CreditPack.create(cents: cents, credits: credits)
end


# Games

minecraft = Game.create(
  name: 'Minecraft',
  individual: true
)

tf2 = Game.create(
  name: 'Team Fortress 2'
)


# Users

chris = User.new(
  username: 'chrislloyd',
  email: 'christopher.lloyd@gmail.com',
  facebook_uid: '219000855'
)

chris.skip_confirmation!
chris.password, chris.password_confirmation = 'password'
chris.admin = true

chris.players.new(game: minecraft, uid: 'christopher.lloyd@gmail.com')

chris.save


dave = User.new(
  username: 'whatupdave',
  email: 'dave@snappyco.de',
  facebook_uid: '709100496'
)

dave.skip_confirmation!
dave.password, dave.password_confirmation = 'password'
dave.admin = true

dave.players.new(game: minecraft, uid: 'dave@snappyco.de')

dave.save!


# Funpacks

Funpack.create(
  name: 'Minecraft Official',
  game: minecraft,
  creator: chris
)

Funpack.create(
  name: 'Team Fortress 2 Official',
  game: tf2,
  creator: chris
)
