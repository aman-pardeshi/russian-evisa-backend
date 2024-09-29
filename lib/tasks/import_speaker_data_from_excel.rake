require 'roo'
require 'securerandom'
# Example rake file structure
# Define a namespace for the task
namespace "importspeakerdatafromexcel" do
    # Give a description for the task
    desc "Import Speaker Data from Excel"
    # Define the task
    task speaker_data_excel: :environment do 
        filename = File.join Rails.root, "public/Dev_Speaker_Directory.xlsx"
        excel = Roo::Excelx.new(filename)
        # excel = Spreadsheet.open filename
        sheet = excel.sheet(0)
        sheet.each do |item|
            id = SecureRandom.random_number(10000)
                value = { 
                    email: item[8],
                    first_name: item[4],
                    last_name: item[5],
                    designation: item[7],
                    company_name: item[6],
                    location: item[10],
                    bio: formating_bio(item[11]),
                    linkedin_url: item[0],
                    image_url: item[9],
                    slug: create_slug(item,id), 
                    degrees: item[12],
                    skills: item[13],
                    reviews_and_mentions: item[15],
                    gender: item[16],
                    birthday: item[14],
                    job_title_id: get_job_title_id(item[2].downcase),
                    industry_id:get_industry_id(item[2].downcase),
                    country_id: 1,
                    position_id: 15
                }
                if !Speaker.where(email: value[:email]).exists?
                    Speaker.create!(value)
                end

                if Speaker.where(email: value[:email]).exists? && item[3].present?
                    data ={
                    speaker_id: Speaker.where(email: value[:email]).first.id,
                    event_id: item[3],
                    invited_by: 0,
                    }
                    if !EventSpeaker.where(speaker_id: data[:speaker_id]).exists?
                        begin
                            EventSpeaker.create!(data)
                        rescue ActiveRecord::RecordInvalid
                            next
                        end
                    end
                end
        end 
        pp "File imported added successfully"   
    end
end

def create_slug(item,id)
    return I18n.transliterate(item[4]).downcase.gsub(/[^a-zA-Z0-9\-]/,"") + "-" + I18n.transliterate(item[5]).downcase.gsub(/[^a-zA-Z0-9\-]/,"") + "-" + id.to_s
end

def random_id
    return rand(10**4)
end

def get_industry_id(item)
    case item
    when 'logistics'
        return 1
    when 'service and support'
        return 2
    when 'e-commerce'
        return 3
    when 'procurement'
        return 4
    when 'customer experience'
        return 5
    when 'automotive'
        return 6
    when 'pharma and healthcare'
        return 7
    when 'manufacturing'
        return 8
    when 'start-up'
        return 9
    when 'Real estate'
        return 10
    when 'energy'
        return 11
    when 'f&b / hospitality'
        return 12
    when 'safety & security'
        return 13
    else
        return nil
    end
end

def get_job_title_id(item)
    case item
    when 'hr'
        return 1
    when 'marketing'
        return 2
    when 'finance'
        return 3
    when 'it'
        return 4
    else
        return nil
    end
end

def formating_bio(str)
  if str.present? and str.class == "String"
    formatted_bio = str.gsub("â€™","'")
      .gsub("â€¯", "")
      .gsub("â€œ", '"')
      .gsub("â€_x009d_", '"')
      .gsub('â€”', "—")
      .gsub('â€“', "—")
      .gsub("Â", "")
      .gsub('"â€‹', '"')
      .gsub("â€¨","")
      .gsub("ï¸_x008f_âƒ£", ".")
      .gsub("â–ª", "▪").gsub("вЂ“", "–")
      .gsub("вЂ”", "–").gsub('вЂ“', "–")
      .gsub("вЂ”", "–").gsub("вЂњ", '"')
      .gsub("вЂќ", '"').gsub("вЂ™","'")
      .gsub("вЂў", "\n•")
      .gsub("–є", "\n- ")
      .gsub("—Џ", "\n•")
      .gsub(".в", ".")
      .gsub("вЂ_x0098_", "'")
      .gsub("вЂ¦", "...")
    return formatted_bio
  end
  return str
end
