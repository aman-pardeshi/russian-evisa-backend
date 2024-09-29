namespace "add_industries_with_slug" do
  desc "add_industries"
  task :add_industry_with_slug => :environment do
    industry = ['Energy', 'F&B / Hospitality', 'Safety & Security']
    industry_slug = ['energy', 'f-and-b-hospitality', 'safety-and-security']
    industry.zip(industry_slug).each do |indstry, indstry_slug|
      industry_attributes = {
        name: indstry,
        slug: indstry_slug
      }
      Industry.create!(industry_attributes)
    end
    puts "Industries added with slug"
  end
end
