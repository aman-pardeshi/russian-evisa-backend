FactoryBot.define do
  factory :coupon, class: Coupon do
    description { Faker::Lorem.sentence }
    discount_percentage { '40' }
    registration_url { Faker::Internet.url }
    validity { DateTime.current }
  end
end
