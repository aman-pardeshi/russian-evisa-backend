class NewScoreCalculation < ApplicationJob
  require 'csv'
  queue_as :default

  def perform(events)
    overall_marketing_events = Event.where(job_title_id: 2).approved

    year_marketing_event = Event.where("job_title_id = ? and start_date > ?", 2, '31/12/2022').approved

    file_path = "#{Rails.root}/public/score_calculation.csv"

    headers = [
      "Event id", 
      "Event Name", 
      ".60", 
      "1.00", 
      "1.40", 
      "1.60", 
      "Total", 
      "Combined Weight", 
      "Combined Personal score & weight", 
      "New Combined High-Quality Adjusted Score", 
      "Sum of Adjusted Mean",
      "Bayesian Average - Rolling",
    ]
    
    # Category Mean calculated for rolling year
    sum_eventible_score = events.pluck(:eventible_score, :total_review).map{ |x, y| x * y}.sum
    sum_total_review = events.pluck(:total_review).sum
    @average_category_mean = sum_eventible_score / sum_total_review

    # Category Mean calculated for yearly
    sum_eventible_score_yearly = year_marketing_event.pluck(:eventible_score, :total_review).map{ |x, y| x * y}.sum
    sum_total_review_yearly = year_marketing_event.pluck(:total_review).sum
    @average_category_mean_yearly = sum_eventible_score_yearly / sum_total_review_yearly

    # Category Mean calculated for Overall
    sum_eventible_score_overall = overall_marketing_events.pluck(:eventible_score, :total_review).map{ |x, y| x * y}.sum
    sum_total_review_overall = overall_marketing_events.pluck(:total_review).sum
    @average_category_mean_overall = sum_eventible_score_overall / sum_total_review_overall

    CSV.open(file_path, "wb") do |csv|
      csv << headers
      events.each do |entry|
        combined_weight = entry.reviews.approved.sum(:weight).round(2)
        combined_personal_score = entry.reviews.approved.sum("personal_score * weight").round(2)
        eventible_score = combined_personal_score /combined_weight

        details = [
          entry.id,
          entry.title,
          entry.reviews.approved.where(weight: 0.60).count,
          entry.reviews.approved.where(weight: 1.00).count,
          entry.reviews.approved.where(weight: 1.40).count,
          entry.reviews.approved.where(weight: 1.60).count,
          entry.reviews.approved.count,
          combined_weight,
          combined_personal_score,
          eventible_score.round(2),
          (eventible_score * entry.reviews.approved.count).round(6),
        ]
        details << calculate_bayesian(entry.reviews.approved.count, eventible_score, @average_category_mean)

        details = details.flatten
        csv << details
      end
    end
  end

  private

  def calculate_bayesian(total_review, eventible_score, category_mean)
    confidence_number = 5
    answer = ((total_review * eventible_score) + (confidence_number * category_mean))/(total_review + confidence_number)
    answer.round(2)
  end

end