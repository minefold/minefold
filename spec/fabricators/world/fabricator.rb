Fabricator(:world) do
  name { Faker::Internet.user_name.gsub('.','_')[0...16] }
  creator fabricator: :user

  game_mode 1
  level_type 'FLAT'
  seed 's33d'
  difficulty 0
  pvp true
  spawn_monsters false
  spawn_animals true
  generate_structures true
  spawn_npcs false
end

Fabricator(:world_upload) do
  world_data_file { "#{Faker::Name.first_name}.tar.gz" }
  user fabricator: :user
  world fabricator: :world
end
