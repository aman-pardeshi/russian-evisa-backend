class SendReviewToHubspotJob < ApplicationJob
    require 'hubspot-api-client'
    
    def perform(review_id)

        api_client = Hubspot::Client.new(access_token: ENV.fetch("HUBSPOT_KEY"))

        begin

            review = Review.find(review_id)
            reviewer = review.reviewer
            event = review.event


            properties = {
                "email": nil,
                "reviewer_id": review.id,
                "firstname": reviewer.name,
                "reviewer_email": reviewer.email,
                "event_id": event.id,
                "event_name": event.title,
                "event_category": event.category.capitalize,
                "event_location": event.country.name,
                "jobtitle": reviewer.designation,
                "company": reviewer.company_name,
                "reviewed_as": review.attended_as,
                "reviewed_on": review.created_at,
                "word_count": review.word_count.to_i,
            }
            body = { properties: properties, associations: [{"to":{"id":"101"}}] }
            api_response = api_client.crm.contacts.basic_api.create(body: body)


        rescue => e
          
            return puts "Error occured in hubspot api"
  
        end
    end

end