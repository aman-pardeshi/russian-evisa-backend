FactoryBot.define do
  factory :audio_review, class: AudioReview do
    audio { Faker::Avatar.image }
    review_id { rand(0...999) }
    event_id { rand(0...999) }
    status { true }
    association :review
    association :event
  end
end
