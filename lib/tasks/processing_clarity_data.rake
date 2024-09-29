namespace "processing_company_data" do
  desc "Process the company_details table and removing the duplicate entries"
  task :clean_data => :environment do 
    duplicate = Hash.new
    companies = CompanyDetail.all.order(:name)

    companies.each do |company|
      dups = CompanyDetail.where(
        domain: company.domain, 
        name: company.name
      ).order(:id)

      next unless dups.size > 1 && !duplicate.key?(company.name)

      duplicate[company.name] = dups.size

      main_company = dups.last
      new_dups_ids = dups.pluck(:id) - [main_company.id]

      VisitorDetail.where(company_detail_id: new_dups_ids).update_all(company_detail_id: main_company.id)

      puts main_company.name
      CompanyDetail.where(id: new_dups_ids).destroy_all
    end

    puts duplicate
  end

  desc "Updating unique slug for every company in company_details"
  task :update_slug_company_details => :environment do 
    companies = CompanyDetail.all.order(:name)

    companies.each do |company| 
      base_slug = company.name.downcase.gsub(/[^a-z0-9\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-').chomp('-')

      base_slug = company.domain.split('.')[0] if base_slug == ""
      company_slug = base_slug
      counter = 1
  
      while CompanyDetail.exists?(slug: company_slug)
        company_slug = "#{base_slug}-#{counter}"
        counter += 1
      end
  
      company.update(slug: company_slug)
    
      puts "#{company.id} - #{company.name} - #{company_slug}"
    end
  end

  desc "Updating users company"
  task :update_users => :environment do 

    # companies = CompanyDetail.all.order(:name)
    # users_companies = User.all.order(:company_name).pluck(:company_name).uniq

    # events = Event.all.order(:id)
    # organizers_ids = events.flat_map{|event| event.event_members.pluck(:user_id)}.sort.uniq
    # organizing_companies = User.where(id: organizers_ids).pluck(:company_name).uniq

    # common_organizing_companies = {}
    # common_user_companies = {}

    # # if organizing_companies.include?(company.name)
    # #   common_organizing_companies[company.name] = 1
    # # end
    # companies.each do |company| 
    #   if users_companies.include?(company.name)
    #     users = User.where(company_name: company.name)
    #     users.each do |user|
    #       user.update(company_detail: company)
    #     end
    #     common_user_companies[company.name] = 1

    #     puts company.name
    #   end
    # end    
    companies = {
      "Sthlm Fintech Week" => "Stockholm Fintech",
      "DPW AMSTERDAM" => "DPW",
      "Dassault Systemes" => "Dassault Systèmes",
      "Terrapinn Holdings Ltd" => "Terrapinn",
      "Consero Group" => "Consero",
      "MarketingProfs B2B Forum" => "MarketingProfs",
      "ACCESS INTELLIGENCE, LLC" => "Access Intelligence",
      "Empire Startups - Everything FinTech" => "Empire Startups",
      "Iowa Bankers" => "Iowa Bankers Association",
      "BizClik Media Group" => "BizClik Media",
      "E-Commerce Berlin EXPO" => "E-Commerce Berlin",
      "Nielsonsmith Ltd." => "Nielsonsmith",
      "Snowflake Inc" => "Snowflake",
      "HubSpot, Inc" => "HubSpot",
      "Cvent Inc" => "Cvent",
      "HR Horizons Inc" => "HR Horizons",
      "DigiMarCon , LLC" => "DigiMarCon",
      "DevNetwork, Inc" => "DevNetwork",
      "Informa Connect Limited" => "Informa Connect",
      "LendIt Conference LLC" => "LendIt Conference",
      "A SALESFORCE COMPANY." => "Salesforce",
      "Emerald X, LLC" => "Emerald X",
      "Morningstar, Inc" => "Morningstar",
      "GS1 US, Inc" => "GS1 US",
      "NurnbergMesse GmbH" => "NurnbergMesse",
      "Customer Relationship Management Conference (CRMC)" => "Customer Relationship Management Conference",
      "CoinDesk, Inc." => "CoinDesk",
      "Healthcare Information and Management Systems Society, Inc." => "Healthcare Information and Management Systems Society",
      "Databricks Inc." => "Databricks",
      "Five9, Inc" => "Five9",
      "UXTesting Inc" => "UXTesting",
      "Anyscale, Inc" => "Anyscale",
      "Messe Dusseldorf GmbH" => "Messe Dusseldorf",
      "Cloud for Utilities, Inc" => "Cloud for Utilities",
      "RISMedia Inc" => "RISMedia",
      "The Global Supply Chain Council (GSCC)" => "The Global Supply Chain Council",
      "KCI World - Good Company" => "KCI World",
      "Startup Events GmbH" => "Startup Events",
      "Wolfsburg AG" => "Wolfsburg",
      "International Foundation of Employee Benefit Plans (IFEBP)" => "International Foundation of Employee Benefit Plans",
      "Seguro Group Inc" => "Seguro Group",
      "Gustav Technologies, Inc" => "Gustav Technologies",
      "National Automobile Dealers Association (NADA)" => "National Automobile Dealers Association",
      "Deutsche Messe AG" => "Deutsche Messe",
      "International Ticketing Association(INTIX)" => "International Ticketing Association",
      "European Blockchain Convention (EBC)" => "European Blockchain Convention",
      "XP Gaming Inc." => "XP Gaming",
      "Amazon Web Services (AWS)" => "Amazon Web Services",
      "The American Institute of Architects (AIA)" => "The American Institute of Architects",
      "Toronto Machine Learning Society (TMLS)" => "Toronto Machine Learning Society",
      "International Personnel Assessment Council (IPAC)" => "International Personnel Assessment Council",
      "National Independent Automobile Dealers Association (NIADA)" => "National Independent Automobile Dealers Association",
      "Ai4 LLC" => "Ai4",
      "Mission Hydrogen GmbH" => "Mission Hydrogen",
      "Smartsheet Inc." => "Smartsheet",
      "Solar Promotion GmbH" => "Solar Promotion",
      "Chemicals America, Inc." => "Chemicals America",
      "DECHEMA Ausstellungs GmbH" => "DECHEMA Ausstellungs",
      "Veeva Systems Inc." => "Veeva Systems",
      "Think11 GmbH" => "Think11",
      "Logistics Summit GmbH" => "Logistics Summit",
      "Trendig technology services GmbH" => "Trendig technology services",
      "Life Science Intelligence, Inc." => "Life Science Intelligence",
      "Koelnmesse GmbH" => "Koelnmesse",
      "MWQHJ LLC 2022" => "MWQHJ",
      "we.CONECT" => "we.CONECT Global Leaders",
      "Founders Foundation gGmbH" => "Founders Foundation",
      "La Cantine Nantes"=> "La Cantine Numérique Nantes",
      "NurnbergMesse" => "NürnbergMesse",
      "Equipe Group 2022" => "Equipe Group",
      "CogX Platform" => "CogX",
      "Federation of European Neuroscience Societies - FENS" => "Federation of European Neuroscience Societies",
      "Convenzis" => "Convenzis Group",
      "Barcelona Java Users Group" => "Barcelona JUG",
      "CogX Platform" => "CogX",
      "Huawei Technologies Co." => "Huawei",
      
    }

    companies.each do |old_name, new_name|
      users = User.where(company_name: old_name)
      p "#{users.count} - #{old_name}"
      users.update(company_name: new_name)
    end
  end

  desc "updating events with company_details id"
  task :update_events => :environment do 

    # file_path = "#{Rails.root}/public/events_organizers.csv"
    # headers = [
    #   "ID", 
    #   "Title", 
    #   "Organizing Company",
    #   "Count",
    #   "Company Details Ids"
    # ]

    events = Event.all.order(:id)
    Clearbit.key = 'sk_2983edb5db5cc99df45982ac98e6dee6'
    companyDataNotFetched = []
    notTaggedEvents = []
    # CSV.open(file_path, "wb") do |csv|
    #   csv << headers
      events.each do |event|
        next if event.company_detail_id.present?
        user_companies = Hash.new
        event_members_ids = event.event_members.where(status: "approved").pluck(:user_id)
  
        users = User.where(id: event_members_ids).where.not(role: "admin")
  
        users.each do |user|
          if (user_companies[user.company_name].present?)
            user_companies[user.company_name] += 1
          else
            user_companies[user.company_name] = 1
          end
        end
  
        org_company_name, org_count = user_companies.sort_by{ |key, value| value}.last

        org_company_name = org_company_name
          .gsub("Limited", "")
          .gsub("Ltd", "")
          .gsub("Ltd.", "")
          .gsub(", LLC", "")
          .gsub("LLC", "") 
          .gsub("GmbH", "")
          .gsub("- Frontend Love", "")
          .gsub("(ODSC)", "")
          .gsub("(ATD)", "")
          .strip if org_company_name.present?
  
        company_details = if org_company_name.present? and org_company_name.include?("A SALESFORCE COMPANY")
          CompanyDetail.where('lower(name) = ?', "salesforce")
        elsif org_company_name.present?
          CompanyDetail.where('lower(name) = ?', org_company_name.downcase)
        else
          nil
        end

        unless company_details.present?
          begin
            fetched_details = if org_company_name == "A SALESFORCE COMPANY."
              Clearbit::NameDomain.find(name: "Salesforce")
            elsif org_company_name === "B2B Marketing Leaders Forum"
              Clearbit::NameDomain.find(name: "B2B Marketing Leaders Forum APAC")
            elsif org_company_name === "KuppingerCole Analysts AG"
              Clearbit::NameDomain.find(name: "KuppingerCole")
            elsif org_company_name === "AWE XR"
              Clearbit::NameDomain.find(name: "AWE")
            elsif org_company_name === "Healthcare Information and Management Systems Society"
              Clearbit::NameDomain.find(name: "HIMSS")
            elsif org_company_name === "Bitkom Service"
              Clearbit::NameDomain.find(name: "Bitkom e. v.")
            elsif org_company_name === "The Heritage and Cultural Society of Africa Foundation:The HACSA Foundation"
              Clearbit::NameDomain.find(name: "The HACSA")
            else 
              Clearbit::NameDomain.find(name: org_company_name)
            end

            if fetched_details.present? 
              company_logo = fetched_details[:logo]
  
              begin
                logo_file = URI.open(fetched_details[:name].downcase.gsub(" ", "_") + ".png", "wb")
                IO.copy_stream(open(company_logo), logo_file)
              rescue 
                p "Logo is not present for this company"
              end
  
              company_details = CompanyDetail.create(
                domain: fetched_details[:domain],
                name: fetched_details[:name],
                logo: logo_file.present? && logo_file.size > 0 ? logo_file : "",
              )
              p "Added #{company_detail.name}"
            else
              
              p org_company_name
              companyDataNotFetched.push("#{event.id}, #{event.title} - #{org_company_name}") unless [
                "LendIt Conference", 
                "We Are Catalyst Media", 
                "Black Is Tech", 
                "LRP Publications", 
                "Vibe Media Group", 
                "i-CEM Institut for Customer Experience Management", 
                "Financial Times Live",
                "Lemberg Tech Business School",
                "PEI Media Group", 
                "Grupa MTP", 
                "Euromoney Institutional Investor PLC group.",
                "Fandango Events LTD",
                "WildApricot by Personify",
                "Africa Fintech Summit",
                "MWQHJ",
                "Trifacta",
                "Quartz Events",
                "Flashpoint Management Consultants UK",
                "SUMAGO Network",
                "Nanotechnology Lab LTFN",
                "Julia Computing",
                "Regal Africa Group",
              ].include?(org_company_name)
            end     
          rescue  
            companyDataNotFetched.push(org_company_name) if org_company_name.present?
            next
          end
        end

        if company_details.present? and company_details.count == 1
          unless event.company_detail_id.present?
            event.update(company_detail:  company_details.first)
          end
        elsif company_details.present? and company_details.count > 1
          notTaggedEvents.push(event.id)
        end
  
        # details = [
        #   event.id,
        #   event.title,
        #   org_company_name,
        #   org_count,
        #   company_details.present? ? company_details.pluck(:id) : "No company exists"
        # ]

        # details = details.flatten
        # csv << details
        puts "#{event.id} #{event.title} - #{org_company_name}"
      end

      byebug

      puts "Not tagged events: #{notTaggedEvents}"
    # end
  end
end
