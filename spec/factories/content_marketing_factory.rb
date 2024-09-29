FactoryBot.define do
  factory :content_marketing, class: ContentMarketing do
    is_allowed_to_video_interview { true }
    is_allowed_to_publish_article { true }
    is_allowed_to_interview { true }
    is_open_for_ideas_discussion { true }
  end
end