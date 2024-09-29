class V1::CalculateReviewersBrandScore
  WEIGHTS_FILE_PATH = "#{Rails.root}/public/weightage.csv".freeze

  def initialize(event, attended_as)
    @event = event
    @attended_as = attended_as
  end

  def total_reviewers_score
    (product_of_review_conference.sum / product_weight_review_conference.sum)
  end

  def last_rolling_year_events
    event_with_editions = Event.where('parent_id = ? OR id = ?', @event.parent_id, @event.parent_id).order('start_date DESC')
    event_with_editions.where(event_with_editions.arel_table[:start_date].between(@event.start_date - 12.months..@event.start_date))
  end

  def reviewers_count
    last_rolling_year_events.map do |event|
      event.reviews.approved.where(attended_as: @attended_as).count.to_f
    end
  end

  def reviewers_average_score
    last_rolling_year_events.map do |event|
      event.personal_average_score(@attended_as).to_f
    end
  end

  def weight_from_weightage_sheet
    file = File.open(WEIGHTS_FILE_PATH)
    data = CSV.parse(file.read)
    data[last_rolling_year_events.count].compact[1..-2].map(&:to_f)
  end

  def product_of_weight_and_eventible_score
    product_event_score = weight_from_weightage_sheet.zip(reviewers_average_score).map do |weight, score|
      score.nil? ? 0.0 : weight * score
    end
  end

  def product_of_review_conference
    product_review_conference = product_of_weight_and_eventible_score.zip(reviewers_count).map do |score, total_review|
      total_review.nil? ? 0.0 : score * total_review
    end
  end

  def product_weight_review_conference
    weight_review_score = weight_from_weightage_sheet.zip(reviewers_count).map do |weight, total_review|
      total_review.nil? ? 0.0 : weight * total_review
    end
  end
end
