Fabricator(:minecraft_player) do
  username { Faker::Internet.user_name.gsub('.','_')[0...16] }
end
