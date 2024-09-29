class CrawlingWebsiteJob < ApplicationJob
    require 'csv'
    queue_as :default

    require 'nokogiri'
    require 'httparty'
    require 'uri'
    require 'open-uri'
  
    def perform(urls_arr, current_user)
        p "job has been started for crawling"

        identifier = ["b2b events", "registration", "tickets", "speakers", "conference", "conferences", 
                        "summit", "summits", "business-to-business events", "industry conferences", 
                        "trade shows", "corporate networking", "corporate meetings", "commercial expos", 
                        "business summits", "trade fairs", "corporate exhibitions", "networking conferences", 
                        "trade conferences", "professional expos", "b2b trade shows", "commercial conferences", 
                        "corporate symposiums", "business events", "trade shows", "industry meetups", 
                        "corporate expos", "professional summits", "b2b conferences", "trade fairs", 
                        "business meet-ups", "meet-ups", "symposiums", "keynote", "keynotes", "register", 
                        "agenda"]
        
        def uri?(string)
            uri = URI.parse(string)
            %w( http https ).include?(uri.scheme)
          rescue URI::BadURIError
            false
          rescue URI::InvalidURIError
            false
        end

        def creating_absolute_path?(url, href)
            absolute_url = true if URI.join(url, href).to_s 
          rescue URI::BadURIError
            false
          rescue URI::InvalidURIError
            false
          rescue
            false
        end

        def crawl(url, depth = 2)
            begin
                return @page_urls if depth.zero? || @page_urls.include?(url) || @page_urls.count >= 40
            
                @page_urls.push(url)

                sleep(0.3)
          
                unparsed_page = HTTParty.get(url)
                parsed_page = Nokogiri::HTML(unparsed_page)
          
                parsed_page.css('a').each do |link|
                    href = link['href']
                    next if href.nil? || href.empty?
            
                    p href

                    if !href.include?("http")

                        if creating_absolute_path?(url, href)
                            absolute_url = URI.join(url, href).to_s
                        end
                    else
                        next
                    end

                    if uri?(absolute_url)
                        crawl(absolute_url, depth - 1)
                    end
                end

            rescue
                p "Invalid url"
            end
        end

        urls_arr.each do |url|

            @page_urls = []
            selected_urls = []
            selected_keywords = []

            crawl(url)

            filtered_links = @page_urls.select { |each_url| each_url.gsub(url, "/").include?("event") }

            filtered_links.each do |each_url| 
                begin
                    response = HTTParty.get(each_url)
                    body = Nokogiri::HTML(response.body) if response.body.present?
                    body.search("head").remove
                    body.search("header").remove
                    body.search("footer").remove
                    body.xpath("//script").remove
                    body.css('style').each(&:remove)

        
                    html = body.text.strip.downcase
    
                    new_arr = identifier.select {|word| html.include?(word) }
                    if new_arr.any?
                        selected_keywords << new_arr
                        selected_urls << each_url
                    end
    
                rescue
                    p "Invalid call for an API..."
                end
            end

            page_links = []

            selected_urls.each_with_index do | element, index |
                page_links << { links: selected_urls[index], keywords: selected_keywords[index] }
            end
            

            if selected_keywords.length > 0
                CrawlingWebsite.where(url: url).update(page_links: page_links, status: 1)
            else
                CrawlingWebsite.where(url: url).update(status: 3)
            end

            sleep(0.5)
        end

        send_mail(urls_arr, current_user)
        p "yes its getting called properly and job ended"
    
    end

    def send_mail(urls_arr, current_user)

        websites = CrawlingWebsite.where(url: urls_arr)

        file_path = "#{Rails.root}/public/uploaded_urls_report.csv"
        headers = [
            "Crawled On",
            "Url",
            "Page Links",
            "Matched Keywords",
            "Status",
        ]

        CSV.open(file_path, "wb") do |csv|
            csv << headers
            websites.each do |entry|

                if entry.page_links

                    entry.page_links.each do |link| 
                        
                        details = [
                            DateTime.parse(entry.created_at.to_s).strftime("%d %b"),
                            entry.url,
                            link["links"],
                            link["keywords"].join(", "),
                            entry.status,
                        ]
                        details = details.flatten
                        csv << details
                    end
                else
                    details = [
                        DateTime.parse(entry.created_at.to_s).strftime("%d %b"),
                        entry.url,
                        "",
                        "",
                        entry.status,
                    ]
                    details = details.flatten
                    csv << details

                end
                
            end
        end

        UserMailer.send_cralwer_details_on_mail(current_user, file_path).deliver!
        system("rm -rf #{file_path}")

    end
end