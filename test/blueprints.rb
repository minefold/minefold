require 'machinist/active_record'

def derp(n)
  (0...n).collect { ('a'..'z').to_a.sample }.length
end


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

CreditPack.blueprint do
  # Stripe requires that charges be at least 50¢. It leads to random test failures otherwise.
  cents { 50 + rand(950) }
  credits { rand(1000) }
end

Game.blueprint do
  name { Faker::Company.name }
end

Funpack.blueprint do
  name { Faker::Company.name }
  game
end

Server.blueprint do
  name { Faker::Company.name }
  funpack
end

Reward.blueprint do
  credits { rand(1000) }
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

Reward.blueprint(:facebook) do
  name { 'facebook linked' }
end
