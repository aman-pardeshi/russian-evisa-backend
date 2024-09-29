FactoryBot.define do
  factory :claim_request, class: ClaimRequest do
    status { ClaimRequest.statuses.keys[rand(ClaimRequest.statuses.keys.length)] }
    association :claimed_by, factory: :user
    association :event
  end
end
