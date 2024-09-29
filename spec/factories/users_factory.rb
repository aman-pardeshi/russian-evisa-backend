FactoryBot.define do
  factory :user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    profile { Faker::Avatar.image }
    password { 'welcome' }
  end
end
