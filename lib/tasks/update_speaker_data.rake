require 'roo'
# Example rake file structure
# Define a namespace for the task
namespace "speakerDataUpdate" do
    # Give a description for the task
    desc "Update Data from Excel"
    task update_excel: :environment do 
        filename = File.join Rails.root, "public/Update_Speaker_Directory.xlsx"
        # excel = Spreadsheet.open filename
        excel = Roo::Excelx.new(filename)
        sheet = excel.sheet(0)
        sheet.each do |item|
            add_review_ids(item[8],item[15])
            
            data = Speaker.where(email: item[8])
            if data.present?
                
                if data.first.reviews_and_mentions.nil?
                    value = { 
                    gender: item[16],
                    reviews_and_mentions: item[15]               
                    }
                    puts data
                    Speaker.where(email: item[8]).update(value)
                end
            end
            
    
        end       
    end
  end


def update_slug(item)
    slug = Speaker.where(email: item[8]).first.slug

    fname = I18n.transliterate(item[4]).gsub(/[^a-zA-Z0-9\-]/,"").downcase
    lname = I18n.transliterate(item[5]).gsub(/[^a-zA-Z0-9\-]/,"").downcase
    id = slug.split("-")[2]
    new_slug = fname + "-" + lname + "-" + id
    
    return new_slug
end

def add_review_ids(email,value)
    
    sp_id = Speaker.where(email: email).first.id
    
    link_arr =  value.split(',')
    id_arr = []
    link_arr.each do |item|
        id = item.split('/').last
        data = {
            speaker_id: sp_id,
            review_id: id.split('?').first
            }
            
        SpeakerReviewMention.create(data)
    end
    
end

