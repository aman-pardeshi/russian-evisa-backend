namespace "export_all_reviews" do
  desc "export_all_reviews_records_to_csv"
  task :export_all_reviews_records_to_csv => :environment do
    CSV_HEADERS =
    ["event name", "review_number", "full name", "attended_as",
    "mode_of_attendance", "company", "designation", "email_id", "event_score", "review_submission_date", "Review Title - Please describe your experience in a short sentence",
    "What did you like best about the event?", "What could the organizers do to improve the event?",
    "How likely is it that you would recommend this event to a friend or colleague?",
    "Did you have a favourite speaker or session? Please tell us below",
    "Overall experience", "Value for money", "Networking opportunities(attendee)",
    "Usefulness of participating vendors/sponsors", "Session(s)",
    "Amount of new information learned", "Overall experience(speaker)",
    "Networking opportunities(speaker)", "Technical support for setting up the session",
    "Interactivity with the audience", "Quality of the audience",
    "Overall experience(sponsor)", "Engagement opportunities with the audience",
    "Fit of the audience for my company", "ROI on spend", "Positive brand exposure",
    "Navigation of virtual platform", "Troubleshooting technical issues",
    "Event destination", "Event venue", "Food and beverages at event",
    "Helpfulness of event staff"
    ]
    file = File.new("./export_all_reviews.csv", "w+")
    CSV.open("./export_all_reviews.csv", "w+") do |csv|
      csv << CSV_HEADERS
      Event.all.each do |event|
        reviews = V1::ExportReview.new(event)
        reviews.calculate.each do |review|
          csv << review
        end
      end
    end
    puts "CSV File generated"
  end
end
