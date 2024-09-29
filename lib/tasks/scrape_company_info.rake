namespace "scrap_company_info" do
  desc "Scape data of companies"
  task :scrap => :environment do 
    require 'clearbit'

    byebug

    Clearbit.key = 'pk_8d3dd8c37cc36468ccfb51f0c7db2abf'

    def get_clearbit_info(company_name)
      begin
        response = Clearbit::NameToDomain.find(name: company_name)
        if response && response['domain']
          domain = response['domain']
          company_info = Clearbit::Company.find(domain: domain, stream: true)
          return {
            domain: domain,
            category: company_info['category'] ? company_info['category']['sector'] : '',
            logo: company_info['logo'],
            description: company_info['description'],
            linkedin_url: company_info['linkedin'] ? "https://www.linkedin.com/company/#{company_info['linkedin']['handle']}" : '',
            country: company_info['geo'] ? company_info['geo']['country'] : ''
          }
        end
      rescue => e
        puts "Error fetching data from Clearbit: #{e.message}"
      end
      {}
    end

    company_names = [
      "East Med Ltd.", "1BusinessWorld", "1st Arabia Tradeshows & Conferences", "A SALESFORCE COMPANY.",
      # Add more companies as needed
    ]

    company_names.each do |company|
      info = get_clearbit_info(company)
      # if info[:linkedin_url].empty?
      #   info[:linkedin_url] = get_linkedin_url(company)
      # end
      puts "Information for #{company}:"
      puts info
    end
  end
end