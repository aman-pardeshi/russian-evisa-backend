require 'roo'
namespace "data_cleanup_for_speaker_table" do
    desc "Cleanup of all the text data for speaker table"
task :data_cleanup_for_speakers => :environment do
    filename = File.join Rails.root, "public/prod-4 Done.xlsx"
    excel = Roo::Excelx.new(filename)
    sheet = excel.sheet(0)
    sheet.each do |item|

        if item[2].present?
            fname = item[2]
        end

        if item[3].present?
            lname = item[3]
        end

        if item[5].present?
            dsg =  item[5]
        end

        if item[4].present?
            comp = item[4]
        end

        if item[9].present?
            bio = item[9]
        end

        if item[10].present?
            deg = item[10]
        end

        if item[11].present?
            skill = item[11]
        end
        
        value = {
                first_name: fname,
                last_name: lname ,
                designation: dsg, 
                company_name: comp,
                bio: bio,
                degrees: deg,
                skills: skill
                }.delete_if { |k,v| v.nil? }
        
        Speaker.where(id: item[0]).update(value)
    
    end
    pp "Cleanup done!!"
end
end
