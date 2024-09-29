namespace "add_slug_to_job_roles" do
  desc "add_slug_to_categories_name"
  task :add_slug => :environment do
    JobTitle.find_each do |job|
      slug = job.name.downcase.gsub(/\s+/, '-')
      job.update(slug: slug)
    end
    Industry.find_each do |industry|
      slug = industry.name.downcase.gsub(/\s+/, '-')
      industry.update(slug: slug)
    end
  puts "Slug added to the categories with updated values"
  end
end
