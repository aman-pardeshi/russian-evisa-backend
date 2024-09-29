FactoryBot.define do
  factory :option, class: Option do
    title { Faker::Name.name }
  end
end
