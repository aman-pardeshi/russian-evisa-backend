FactoryBot.define do
  factory :organizer_enquiry, class: OrganizerEnquiry do
    name { Faker::Name.name }
    company { Faker::Company.name }
  end
end
