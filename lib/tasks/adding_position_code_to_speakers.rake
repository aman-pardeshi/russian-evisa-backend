namespace "adding_position_code_to_speakers" do
  desc "add_position_code"
  task :add_position_code => :environment do

    project_management_db = Expertise.where(name: 'Project Management').first
    business_strategy_db = Expertise.where(name: 'Business Strategy').first
    leadership_db = Expertise.where(name: 'Leadership').first
    marketing_db = Expertise.where(name: 'Marketing').first
    social_media_db = Expertise.where(name: 'Social Media').first
    entrepreneurship_db = Expertise.where(name: 'Entrepreneurship').first
    business_product_development_db = Expertise.where(name: 'Business/Product Development').first
    public_speaking_db = Expertise.where(name: 'Public Speaking').first
    sales_db = Expertise.where(name: 'Sales').first
    it_db = Expertise.where(name: 'IT/Tech').first
    analysis_db = Expertise.where(name: 'Analysis').first
    advertising_db = Expertise.where(name: 'Advertising').first
    public_relation_db = Expertise.where(name: 'Public Relations').first
    finance_db = Expertise.where(name: 'Finance').first
    human_resouces_db = Expertise.where(name: 'Human Resources Management').first
    copywriting_db = Expertise.where(name: 'Copywriting').first
    teaching_db = Expertise.where(name: 'Teaching').first

    speakers = Speaker.all.order(:id)

    position_hash = Hash.new(0)
    country_hash = Hash.new(0)
    skills_hash = Hash.new(0)
    noposition = []

    manager_position_db = Position.where(name: 'Manager').first
    partner_position_db = Position.where(name: 'Partner').first
    director_position_db = Position.where(name: 'Director').first
    vp_position_db = Position.where(name: 'President/Vice-President').first
    c_level_position_db = Position.where(name: 'C-level').first
    other_position_db = Position.where(name: 'Others').first

    speakers.map do |speaker|
      # Updating position code for speakers
      position = speaker.designation.present? ? speaker.designation.downcase : nil

      if position.present?
        manager_position = position.include?('manager') ||
        position.include?('pm') || 
        position.include?('mgr') ||
        position.include?('teacher') || 
        position.include?('professor') || 
        position.include?('lecturer') || 
        position.include?('educator') ||
        position.include?('trainer') ||
        position.include?('mentor') ||
        position.include?('prof.') ||
        position.include?('author') || 
        position.include?('writer') || 
        position.include?('editor') ||
        position.include?('journalist') || 
        position.include?('anchor') ||
        position.include?('host') || 
        position.include?('reporter') ||
        position.include?('presenter') || 
        position.include?('engineer') || 
        position.include?('developer') || 
        position.include?('programmer') || 
        position.include?('architect') || 
        position.include?('designer') || 
        position.include?('artist') ||
        position.include?('scientist')
  
        partner_position = position.include?('partner') ||
        position.include?('investor') ||
        position.include?('shareholder') ||
        position.include?('advisor') || 
        position.include?('lawyer') || 
        position.include?('advocate') || 
        position.include?('judge') || 
        position.include?('attorney') || 
        position.include?('counsel') || 
        position.include?('counsellor')
  
        director_position = position.include?('director') ||
        position.include?('gm') || 
        position.include?('directrice') || 
        position.include?('principal') || 
        position.include?('directeur') ||
        position.include?('consultant') || 
        position.include?('strategist')

        vp_position = position.include?('vice president') || 
        position.include?('vp') || 
        position.include?('head') || 
        position.include?('v.p') || 
        position.include?('president') ||
        position.include?('minister') ||
        position.include?('mayor') ||
        position.include?('congressman') ||
        position.include?('senator') ||
        position.include?('ambassador') || 
        position.include?('councillor') || 
        position.include?('council member') ||
        position.include?('governor')

  
        c_level_position = position.include?('chief') || 
        position.include?('founder') || 
        position.include?('chro') ||
        position.include?('ciso') ||
        position.include?('ceo') ||
        position.include?('coo') ||
        position.include?('cio') ||
        position.include?('cto') ||
        position.include?('cfo') ||
        position.include?('cmo') ||
        position.include?('cao') ||
        position.include?('cso') ||
        position.include?('cpo') ||
        position.include?('cco') ||
        position.include?('cro') ||
        position.include?('cdo') ||
        position.include?('cko') ||
        position.include?('cbo') ||
        position.include?('fondatore') ||
        position.include?('fondatrice') ||
        position.include?('fondateur') ||
        position.include?('chair') ||
        position.include?('md') ||
        position.include?('c.e.o') ||
        position.include?('cxo') || 
        position.include?('owner') ||
        position.include?('leader')

  
        if manager_position 
          speaker.update(position_id: manager_position_db.id)
        end

        if partner_position 
          speaker.update(position_id: partner_position_db.id)
        end

        if director_position 
          speaker.update(position_id: director_position_db.id)
        end

        if vp_position 
          speaker.update(position_id: vp_position_db.id)
        end

        if c_level_position
          speaker.update(position_id: c_level_position_db.id)
        end

        if !c_level_position and !vp_position and !director_position and !partner_position and !manager_position
          speaker.update(position_id: other_position_db.id)
        end
      end

      # Updating country code to speakers
      country = speaker.location.present? ? speaker.location.split(',').last.squeeze('').strip : nil
      country_id = Country.where(name: country).first
      if country 
        if country_id.present?
          speaker.update(country_id: country_id.id)
          puts "#{speaker.first_name}'s country is updated with #{country_id.name}"
        elsif (country == "New York City Metropolitan Area" ||
          country == "San Francisco Bay Area" ||
          country == "Greater Chicago Area" ||
          country == "Greater Boston" ||
          country == "Los Angeles Metropolitan Area" ||
          country == "Dallas-Fort Worth Metroplex" ||
          country == "Greater Tampa Bay Area" ||
          country == "Atlanta Metropolitan Area"
          country == "Washington DC-Baltimore Area" ||
          country == "Greater Minneapolis-St. Paul Area" ||
          country == "Greater Philadelphia" ||
          country == "Greater Seattle Area" ||
          country == "Greater Orlando" ||
          country == "Denver Metropolitan Area" ||
          country == "Texas Metropolitan Area" ||
          country == "Greater Cleveland" ||
          country == "Piscataway" ||
          country == "Salt Lake City Metropolitan Area" ||
          country == "Miami-Fort Lauderdale Area" ||
          country == "Greater Houston" ||
          country == "Nashville Metropolitan Area" ||
          country == "Detroit Metropolitan Area" ||
          country == "Greater Pittsburgh Region" ||
          country == "San Francisco Bay Area" ||
          country == "New York City Metropolitan Area" ||
          country == "Greater Chicago Area" ||
          country == "Greater Boston" ||
          country == "Los Angeles Metropolitan Area" ||
          country == "Dallas-Fort Worth Metroplex" ||
          country == "Greater Tampa Bay Area"
        )
          speaker.update(country_id: 1)
        elsif country == "Russia"
          speaker.update(country_id: 191)
        elsif country == "Hong Kong SAR"
          speaker.update(country_id: 3)
        elsif country == "United Arab Emirates"
          speaker.update(country_id: 7)
        elsif country == "Czechia"
          speaker.update(country_id: 73)
        elsif country == "South Korea"
          speaker.update(country_id: 128)
        elsif country == "Taiwan"
          speaker.update(country_id: 222)
        elsif country == "Vietnam"
          speaker.update(country_id: 243)
        elsif country == "CÃ´te d'Ivoire"
          speaker.update(country_id: 68)
        elsif country == "The Bahamas"
          speaker.update(country_id: 30)
        elsif country == "Tanzania"
          speaker.update(country_id: 224)
        elsif country == "Iran"
          speaker.update(country_id: 114)
        elsif country == "Democratic Republic of the Congo"
          speaker.update(country_id: 65)
        elsif country == "Syria"
          speaker.update(country_id: 221)
        elsif country == "Venezuela"
          speaker.update(country_id: 242)
        elsif country == "Bolivia"
          speaker.update(country_id: 40)
        elsif country == "Greater Paris Metropolitan Region"
          speaker.update(country_id: 12)
        elsif country == "Greater Barcelona Metropolitan Area"
          speaker.update(country_id: 6)
        end
      end

      # Updating skill id for speakers
      skill = speaker.skills.present? ? speaker.skills.downcase : nil
      
      if skill.present? 
        management_skill = skill.include?('management') || skill.include?('team building') || skill.include?('event planning')

        stratedy_skill = skill.include?('strategy') || skill.include?('strategic') || skill.include?('business planning')

        leadership_skill = skill.include?('leadership')

        marketing_skill = skill.include?('marketing') || skill.include?('seo') || skill.include?('networking') || skill.include?('lead generation') || skill.include?('sem') || skill.include?('community outreach') || skill.include?('demand generation')

        social_media_skill = skill.include?('social media') || skill.include?('digital media')

        entrepreneurship_skill = skill.include?('entrepreneurship') || skill.include?('start-ups')

        business_development_skill = skill.include?('business development') || skill.include?('product development') || skill.include?('software development') || skill.include?('agile methodologies') || skill.include?('project planning') || skill.include?('process improvement') || skill.include?('business intelligence') || skill.include?('brand development') || skill.include?('user experience') || skill.include?('user interface design') || skill.include?('product launch') || skill.include?('software design')

        public_speaking_skill = skill.include?('public speaking') || skill.include?('communication')

        sales_skill = skill.include?('sales') || skill.include?('negotiation') || skill.include?('customer service') || skill.include?('customer experience')

        it_skills = skill.include?('cloud computing') || skill.include?('java') || skill.include?('sql') || skill.include?('javascript') || skill.include?('python') || skill.include?('linux') || skill.include?('c++') || skill.include?('saas') || skill.include?('machine learning') || skill.include?('html') || skill.include?('web development') || skill.include?('software engineering') || skill.include?('matlab') || skill.include?('programming') || skill.include?('data science') || skill.include?('aws') || skill.include?('unix') || skill.include?('information technology') || skill.include?('web design') || skill.include?('information security') || skill.include?('c#') || skill.include?('big data') || skill.include?('artificial intelligence') || skill.include?('cybersecurity') || skill.include?('devops')

        analysis_skill = skill.include?('analysis') || skill.include?('analytics')

        advertising_skill = skill.include?('advertising') || skill.include?('google adwords')

        public_relation_skill = skill.include?('public relations') || skill.include?('international relations')

        finance_skill = skill.include?('finance') || skill.include?('mergers & acquisitions') || skill.include?('financial modeling') || skill.include?('risk management') || skill.include?('venture capital') || skill.include?('due diligence') || skill.include?('investments') || skill.include?('private equity') || skill.include?('budgets') || skill.include?('valuation') || skill.include?('fundraising') || skill.include?('financial services') || skill.include?('emerging markets') || skill.include?('economics') || skill.include?('statistics') || skill.include?('mergers') || skill.include?('investment banking') || skill.include?('portfolio Management') || skill.include?('asset management') || skill.include?('disaster recovery') || skill.include?('accounting') || skill.include?('hedge funds')

        human_resouces_skill = skill.include?('human resources') || skill.include?('crm') || skill.include?('recruiting') || skill.include?('employee engagement') || skill.include?('governance') || skill.include?('corporate law')

        teaching_skill = skill.include?('teaching') || skill.include?('coaching') || skill.include?('mentoring')

        copywriting_skill = skill.include?('copywriting') || skill.include?('writing') || skill.include?('copy editing')

        if management_skill
          management_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: project_management_db.id)
          management_entry.save!
        end
        
        if stratedy_skill
          stratedy_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: business_strategy_db.id)
          stratedy_entry.save!
        end

        if leadership_skill
          leadership_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: leadership_db.id)
          leadership_entry.save!
        end

        if marketing_skill
          marketing_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: marketing_db.id)
          marketing_entry.save!
        end

        if social_media_skill 
          social_media_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: social_media_db.id)
          social_media_entry.save!
        end

        if entrepreneurship_skill
          entrepreneurship_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: entrepreneurship_db.id)
          entrepreneurship_entry.save!
        end

        if business_development_skill
          business_development_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: business_product_development_db.id)
          business_development_entry.save!
        end

        if public_speaking_skill
          public_speaking_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: public_speaking_db.id)
          public_speaking_entry.save!
        end

        if sales_skill
          sales_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: sales_db.id)
          sales_entry.save!
        end

        if it_skills
          it_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: it_db.id)
          it_entry.save!
        end

        if analysis_skill
          analysis_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: analysis_db.id)
          analysis_entry.save!
        end

        if advertising_skill
          advertising_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: advertising_db.id)
          advertising_entry.save!
        end

        if public_relation_skill
          public_relation_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: public_relation_db.id)
          public_relation_entry.save!
        end

        if finance_skill
          finance_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: finance_db.id)
          finance_entry.save!
        end

        if human_resouces_skill
          human_resource_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: human_resouces_db.id)
          human_resource_entry.save!
        end

        if teaching_skill
          teaching_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: teaching_db.id)
          teaching_entry.save!
        end

        if copywriting_skill
          copywriting_entry = SpeakersExpertise.new(speaker_id: speaker.id, expertise_id: copywriting_db.id)
          copywriting_entry.save!
        end
      end
    end
    # position_hash.map do |m, n|
    #   puts "#{m} = #{n}"
    # end
    # puts "noposition count = #{noposition.uniq.count}" 

    # country_hash.sort_by {|_key, value| value}.map do |m, n|
    #    puts "#{m} = #{n}"
    # end
  
  end
end