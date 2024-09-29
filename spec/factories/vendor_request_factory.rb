FactoryBot.define do
  factory :vendor_request, class: VendorRequest do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    company_name { Faker::Name.name }
    designation { Faker::Job.field }
  end
end
