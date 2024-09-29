class V1::CalculateBayesianAverage

  def initialize(eventible_score, review)
    @eventible_score = eventible_score
    @review = review
    @category = @review.event.job_title_id == 0 ? "industry" : "job_title"
    @category_id = @review.event.job_title_id == 0 ? @review.event.industry_id : @review.event.job_title_id

    @events = @review.event.job_title_id == 0 ? Event.where(industry_id: @category_id).where(Event.arel_table[:end_date].between(DateTime.now - 365..DateTime.now).and(Event.arel_table[:total_review].gt(0))).approved : Event.where(job_title_id: @category_id).where(Event.arel_table[:end_date].between(DateTime.now - 365..DateTime.now).and(Event.arel_table[:total_review].gt(0))).approved
  end

  def bayesian_average
    number_of_reviews = @review.event.total_review
    confidence_number = 5

    answer = ((number_of_reviews * @eventible_score) + (confidence_number * category_mean)) / (number_of_reviews + confidence_number)
    answer.round(2)
  end

  def category_mean
    sum_product_eventible_score_and_total_review / sum_total_review
  end

  def sum_product_eventible_score_and_total_review
    @events.sum("eventible_score * total_review")
  end

  def sum_total_review
    @events.sum("total_review")
  end
end