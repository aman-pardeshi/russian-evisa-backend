module V1::Events
  def self.is_top_rated?(event)
    past_edition = Event.where("brand_url = ? AND start_date < ?", event.brand_url, event.start_date).order(end_date: :desc).first
    
    past_edition.present? && past_edition.eventible_score >= 4.5 && past_edition.total_review >= 5 ?
      true : false
  end

  def self.find_parents(event, parent_id)
    event.parent.present? ?
    find_parent(event.parent, parent_id << event.parent.id)
      : parent_id
  end
end