FactoryBot.define do
  factory :review_submission, class: ReviewSubmission do
    answer { Faker::Name.name }
  end
end
