def sluggify name
  name.downcase.gsub ' ', '-'
end

FactoryGirl.define do

  sequence :username do |n|
    "Mod#{n}"
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    username
    email
    slug { sluggify username }
    password 'carlsmum'
    password_confirmation 'carlsmum'
  end

  factory :world do
    sequence(:name) {|n| "World #{n}"}
    
    slug { sluggify name }
    
    association :creator, factory: :user
  end

end
