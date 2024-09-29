class V1::CalculateEventBadges

  def initialize(event)
    @event = event
  end

  def event_badges
    @event.most_popular_badge(@event.id) || 
    @event.most_loved_badge(@event.job_title_id) ||
    @event.top_rated_badge(@event.job_title_id, @event.industry_id, @event.id) ||
    @event.ranked_one_badge(@event.job_title_id, @event.industry_id, @event.id) ||
    @event.ranked_third_badge(@event.job_title_id, @event.industry_id, @event.id) ||
    @event.ranked_tenth_badge(@event.job_title_id, @event.industry_id, @event.id) ||
    @event.best_for_learning_badge(@event.id) ||
    @event.best_for_networking_badge(@event.id) ||
    @event.most_recommended_badge(@event.id)
  end
end