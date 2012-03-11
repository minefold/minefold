Fabricator(:minecraft_account) do
  username { Faker::Name.first_name }
end
