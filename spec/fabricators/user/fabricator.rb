Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  password_confirmation 'password'
  confirmed_at 1.week.ago
  minecraft_player fabricator: :minecraft_player
end
