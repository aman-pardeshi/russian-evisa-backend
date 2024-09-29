module V1
  class OrganizerDashboardEventSerializer < CacheCrispies::Base
    collection_key :data
    serialize :id, :title, :description, :logo,
       :start_date, :end_date, :total_review,
      :eventible_score, :edition, :slug, :brand_score, :event_type, :awards, :job_title, :industry, :event_images
    serialize :attendee, :speaker,
      :sponsor, :overall_score, :category, :audio_count,
      :uncommented_review, :bookmarked_count, :analysis_report
      serialize :most_popular_badge, :most_loved_badge, :top_rated_badge, :ranked_third_badge,
                :ranked_tenth_badge, :best_for_learning_badge, :best_for_networking_badge,
                :ranked_one_badge, :most_recommended_badge

    def awards
      model.badges.as_json(only: [:id, :badge_name, :badge_description, :year])
    end

    def job_title
      model&.job_title&.name
    end

    def industry
      model&.industry&.name
    end

    def event_images
      model.event_edition_images(model&.id)
    end

    def attendee
      { count: model.reviews&.attendee&.approved&.count,
        score: model.personal_average_score('attendee')
      }
    end

    def speaker
      { count: model.reviews&.speaker&.approved&.count,
        score: model.personal_average_score('speaker')
      }
    end

    def sponsor
      { count: model.reviews&.sponsor&.approved&.count,
        score: model.personal_average_score('sponsor')
      }
    end

    def eventible_score
      model.round_eventible_score
    end

    def brand_score
      model.round_brand_score
    end

    def overall_score
      ("%.2f" % model.eventible_score)
    end

    def logo
      if model.logo.url.nil? && model.parent.present?
        model.parent.logo
      else
        model.logo
      end
    end

    def audio_count
      model.audio_count
    end

    def uncommented_review
      model.uncommented_review
    end

    def bookmarked_count
      model&.reviews.where(is_saved: true).count
    end

    def most_popular_badge
      model.most_popular_badge(model&.id)
    end

    def most_loved_badge
      model.most_loved_badge(model&.job_title_id)
    end

    def top_rated_badge
      model.top_rated_badge(model&.job_title_id, model&.industry_id, model&.id)
    end

    def ranked_one_badge
      model.ranked_one_badge(model&.job_title_id, model&.industry_id, model&.id)
    end

    def ranked_third_badge
      model.ranked_third_badge(model&.job_title_id, model&.industry_id, model&.id)
    end

    def ranked_tenth_badge
      model.ranked_tenth_badge(model&.job_title_id, model&.industry_id, model&.id)
    end

    def best_for_learning_badge
      model.best_for_learning_badge(model&.id)
    end

    def best_for_networking_badge
      model.best_for_networking_badge(model&.id)
    end

    def most_recommended_badge
      model.most_recommended_badge(model&.id)
    end
  end
end
