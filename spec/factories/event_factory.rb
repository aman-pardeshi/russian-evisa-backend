FactoryBot.define do
  factory :event, class: Event do
    title { Faker::Name.name }
    url_name { Faker::Name.initials(number: 10)}
    brand_url { Faker::Name.name }
    edition { Faker::Name.name }
    logo { Faker::Avatar.image }
    banner { Faker::Avatar.image }
    description { Faker::Lorem.paragraph }
    agenda_file { Faker::Avatar.image }
    event_type { 'virtual' }
    start_date { DateTime.current.change(hour: 10) }
    end_date { DateTime.current.change(hour: 15) }
    venue { Faker::Address.full_address }
    registration_url { Faker::Avatar.image }
    price { rand(0...999) }
    coupoun_code { rand(0...999).to_s }
    discount_percentage { rand(0...999) }
    status { 'pending' }
    association :job_title
    association :country
  end
end
