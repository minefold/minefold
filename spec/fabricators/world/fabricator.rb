Fabricator(:world) do
  name { Faker::Company.name }
  creator fabricator: :user
end

Fabricator(:world_upload) do
  world_data_file { "#{Faker::Name.first_name}.tar.gz" }
  uploader fabricator: :user
  world fabricator: :world
end
