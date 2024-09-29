FactoryBot.define do
  factory :campaign_link, class: CampaignLink do
    expiry_date { Date.current }
    reward_amount { 20 }
    link_tbr { Faker::Internet.url }
    association :created_by, factory: :user
  end
end
