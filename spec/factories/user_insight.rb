FactoryBot.define do
  factory :user_insight, class: UserInsight do
    is_bookmarked { false }
    is_insightful { false }
  end
end
