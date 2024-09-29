require 'hubspot-api-client'

namespace "send_review_to_hubspot" do
    desc "send_review_data_to_hubspot_table"
    task :send_review_data_to_hubspot_table => :environment do

        api_client = Hubspot::Client.new(access_token: ENV.fetch("HUBSPOT_KEY"))
        

        no_of_loops_to_run = Review.approved.order(:id).length/100 + 1

        begin

          no_of_loops_to_run.times do |number|

            review_arr = []

            reviews = Review.approved.slice(number*100, 100)

            reviews.each do |review|
              reviewer = review.reviewer
              event = review.event

              single_review_obj = {"properties": {
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
              }

              review_arr << single_review_obj

            end

                
            body = { inputs: review_arr}

            api_response = api_client.crm.contacts.batch_api.create(body: body)
            puts "Reviews send to hubspot from #{number*100} to #{number*100 + 100}"

          end  

        rescue => e
          
          return puts "Error occured in hubspot api"

        end

        puts "Successfully sent review data to hubspot table"
    end
end