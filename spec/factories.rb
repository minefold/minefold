FactoryGirl.define do

  sequence :username do |n|
    "person#{n}"
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    username
    email
    password 'carlsmum'
    password_confirmation 'carlsmum'
  end

  factory :world do
    sequence(:name) {|n| "World #{n}"}
  end

end
