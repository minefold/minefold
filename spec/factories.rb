FactoryGirl.define do

  sequence :username do |n|
    "user#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    username
    email
    password 'password'
    password_confirmation 'password'
  end

  factory :world do
    sequence(:name) {|n| "World #{n}"}
    association :creator, factory: :user
    sequence(:world_data_file) {|n| "world-#{n}.tar.gz"}
  end

end
