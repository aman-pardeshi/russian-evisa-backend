class SendNewsletterMailJob < ApplicationJob

  def perform(event_review_arr, users, newsletter_details)
      
    users.each do |user|
      begin
        next if user.is_email_invalid.present? || user.unsubscribe_status.present?

        response = HTTParty.get("https://api.hunter.io/v2/email-verifier?email=#{user.email}&api_key=#{ENV.fetch("HUNTER_API_KEY")}")

        if ((response["data"]["status"] != "invalid" || response["data"]["status"] != "unknown") && response["data"]["score"] >= 70)

          # newsletter_event_details
          upcoming_events_arr = []
          edition = ""

          subscriber = User.find_by(email: user.email) || Guest.find_by(email: user.email)

          subscriber_type = User.find_by(email: user.email).present? && user == subscriber ? "User" : "Guest"

          newsletter = Newsletter.new(
            subscriber_type: subscriber_type,
            subscriber_id: user.id,
            category: newsletter_details[:category],
            month: newsletter_details[:month],
            year: newsletter_details[:year],
            is_dark_mode: newsletter_details[:dark_mode]
          )

          if newsletter.valid?
            newsletter.save!
          end

          event_review_arr.each do |each_event_rev_obj|

            event_id = each_event_rev_obj["event_id"]
            review_id = each_event_rev_obj["review_id"]
            
            if event_id.present? && review_id.present?
                  
              event = Event.find(event_id)
              pre_edition_event_id = Event.where("parent_id = :id OR id = :id", id: event.parent_id).order(:start_date)[-2].id
              review = Review.find(review_id)

              edition = event.start_date.strftime("%B, %Y")

              rev_info = news_reviewer_info(review.reviewer_type, review.reviewer_id, event_id, review.id)

              tracking_details = NewsletterEvent.new(
                newsletter: newsletter,
                event: event, 
              )

              if tracking_details.valid? 
                tracking_details.save!
              end
             
              each_obj = {
                event_logo: event.event_logo,
                event_title: event.title,
                elp_link: "#{ENV.fetch("FRONTEND_URL")}/#{event.category}/#{event.slug}?trigger=newsletter&triggerid=#{tracking_details.id}",
                start_date: event.start_date.strftime("%d %b, %Y"),
                end_date: event.end_date.strftime("%d %b, %Y"),
                checking_for_learning_badge: event.best_for_learning_badge(pre_edition_event_id),
                checking_for_networking_badge: event.best_for_networking_badge(pre_edition_event_id),
                profile: rev_info[3],
                name: rev_info[4],
                designation: rev_info[1],
                company: rev_info[0],
                review_title: review.review_submissions.where(
                  question:
                  Question.find_by_title("Review Title - Please describe your experience in a short sentence")
                ).first.answer,
                registration_tag: each_event_rev_obj["registration_tag"],
                interesting_link: "#{ENV.fetch("FRONTEND_URL")}/newsletter-confirmation?&event_id=#{event_id}&user_email_id=#{user.email}&trigger=newsletter&triggerid=#{tracking_details.id}",
                event_tracking_id: tracking_details.id
              }

              upcoming_events_arr << each_obj   
            end
          end
          
          mail_details = {
            event: upcoming_events_arr,
            edition: edition,
            user: user,
            newsletter: newsletter
          } 

          if newsletter_details[:dark_mode] == true
            UserMailer.send_newsletter_test_mail(mail_details, user.email).deliver!
          else 
            UserMailer.send_newsletter_test_mail_light(mail_details, user.email).deliver!
          end

        else
          user = user.update(is_email_invalid: true)
        end   
      rescue => error
        p "error occured in an hunter api, #{error}"
      end  
    end
  end

  # methods

  def news_reviewer_info(value, id, event_id, reviewer_id)
    if value == 'User'
      user = User.find(id)
      company_name = user.company_name
      designation = user.designation
      if user.profile.present?
          img = {url: user.profile.url}
      elsif user.get_profile_url.present?
          img = {url: user.get_profile_url["url"]}
      else
          img = {url: nil} 
      end
      name = user.name
      email = user.email
      link = ""
      return [ company_name, designation, link , img, name, email]
    else
      guest = Guest.find(id)
      company_name = guest.company_name
      designation = guest.designation
      img = {url: nil}
      name = guest.name
      email = guest.email
      link = ""
      return [ company_name, designation , link, img, name, email]
    end
  end
end