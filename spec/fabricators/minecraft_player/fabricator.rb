Fabricator(:minecraft_player) do
  username { Faker::Internet.user_name.gsub('.','_')[0...12] + rand(1000).to_s }
end
