namespace "adding_data_to_position_skills" do
  desc "add_initial_data"
  task :add_initial_data => :environment do

    positions_data = [
      'CEO', 
      'Marketing', 
      'Event', 
      'Demand Generation', 
      'Digital', 
      'Content', 
      'Social Media', 
      'Growth Marketing', 
      'Paid Marketing', 
      'C-level', 
      'President/Vice-President', 
      'Director', 
      'Partner', 
      'Manager',
      'Others'
    ]

    skills_data = [
      'Project Management', 
      'Business Strategy', 
      'Leadership', 
      'Marketing', 
      'Social Media', 
      'Entrepreneurship', 
      'Business/Product Development', 
      'Public Speaking', 
      'Sales', 
      'IT/Tech', 
      'Analysis', 
      'Advertising', 
      'Public Relations',
      'Finance',
      'Human Resources Management',
      'Copywriting', 
      'Teaching'
    ]

    positions_data.each do |position|
      position = Position.new(name: position)
      position.save!
    end

    skills_data.each do |skill|
      skill = Expertise.new(name: skill)
      skill.save!
    end

    puts "Added initial data for user position and Expertise"
  end
end