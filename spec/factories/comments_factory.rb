FactoryBot.define do
  factory :comment, class: Comment do
    review_id { rand(0...999) }
    user_id { rand(0...999) }
    description { Faker::Lorem.paragraph }
    status { Faker::Name.name }
    association :review
    association :user
  end
end
