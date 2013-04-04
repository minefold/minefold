require 'machinist/active_record'

User.blueprint do
  username { Faker::Internet.user_name }
  email    { Faker::Internet.email }
  password { 'password' }
  password_confirmation { 'password' }
end

Account.blueprint do
  user
  uid { Faker::Internet.user_name }
end

Accounts::Mojang.blueprint do
  user
  uid { Faker::Internet.user_name }
end

CoinPack.blueprint do
  # Stripe requires that charges be at least 50¢. It leads to random test failures otherwise.
  cents { 50 + rand(950) }
  coins { rand(1000) }
end

Funpack.blueprint do
  game { GAMES.find('team-fortress-2') }
  name { Faker::Company.name }
  settings_schema { {} }
end

Server.blueprint do
  creator
  name { Faker::Company.name }
  funpack
  party_cloud_id { SecureRandom.uuid }
end

World.blueprint do
  server
  last_mapped_at { Time.now }
end

Bonuses::ReferredFriend.blueprint do
end

Plan.blueprint do
  name      { 'Silver' }
  cents     { 50 + rand(950) }
  bolts     { rand(10) }
  stripe_id { "plan_#{rand(1000)}" }
end


# --

Funpack.blueprint(:minecraft) do
  game(:minecraft)
end

Funpack.blueprint(:tf2) do
  game { GAMES.find('team-fortress-2') }
end

Server.blueprint(:minecraft) do
  funpack(:minecraft)
end

Server.blueprint(:tf2) do
  funpack(:tf2)
end

Server.blueprint(:played) do
  party_cloud_id { SecureRandom.uuid }
  world { World.make!(party_cloud_id: SecureRandom.uuid) }
end

