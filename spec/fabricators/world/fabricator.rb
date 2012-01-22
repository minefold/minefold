Fabricator(:world) do
  name { Faker::Company.name }
  creator fabricator: :user
end
