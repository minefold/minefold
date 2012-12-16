require 'machinist/active_record'

User.blueprint do
  username { Faker::Internet.user_name }
  email    { Faker::Internet.email }
  password { 'password' }
  password_confirmation { 'password' }
end

Player.blueprint do
  game
  user
  uid { Faker::Internet.user_name }
end

CoinPack.blueprint do
  # Stripe requires that charges be at least 50¢. It leads to random test failures otherwise.
  cents { 50 + rand(950) }
  coins { rand(1000) }
end

Game.blueprint do
  name { Faker::Company.name }
end

Funpack.blueprint do
  name { Faker::Company.name }
  game
end

Server.blueprint do
  creator
  name { Faker::Company.name }
  funpack
end

World.blueprint do
end


# --

Game.blueprint(:minecraft) do
  name { 'Minecraft' }
end

Funpack.blueprint(:minecraft) do
  game(:minecraft)
end

Server.blueprint(:minecraft) do
  funpack(:minecraft)
end

Server.blueprint(:played) do
  party_cloud_id { SecureRandom.uuid }
  world { World.make!(party_cloud_id: SecureRandom.uuid) }
end

