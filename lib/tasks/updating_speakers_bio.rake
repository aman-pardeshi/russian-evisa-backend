namespace "update_speakers_bio" do
  desc "updating_bio"
  task :updating_bio => :environment do
    @speakers = Speaker.where.not(id: nil)
    puts @speakers.length
    @speakers.each do |speaker|
    
      if speaker.bio.present? and speaker.bio.class === "String"
        puts "#{speaker.first_name} #{speaker.last_name}"
        formatted_bio = speaker.bio.gsub("â€™","'")
          .gsub("â€¯", "")
          .gsub("â€œ", '"')
          .gsub("â€_x009d_", '"')
          .gsub('â€”', "—")
          .gsub('â€“', "—")
          .gsub("Â", "")
          .gsub('"â€‹', '"')
          .gsub("â€¨","")
          .gsub("ï¸_x008f_âƒ£", ".")

          formated_bio_arr = formatted_bio.split("\n")
          encoded_bio = []
          formated_bio_arr.each do |sentence|
            begin
              if sentence.encode("Windows-1252"). force_encoding("UTF-8").valid_encoding?
                encoded_bio << sentence.encode("Windows-1252").force_encoding("UTF-8")
              else
                encoded_bio << sentence
              end
              encoded_bio.join("\n").gsub("â–ª", "▪").gsub("вЂ“", "–").gsub("вЂ”", "–")

              speaker.update(bio: encoded_bio.join("\n"))

            rescue Encoding::UndefinedConversionError
              rescueStr = speaker.bio.gsub('вЂ“', "–")
              .gsub("вЂ”", "–")
              .gsub("вЂњ", '"')
              .gsub("вЂќ", '"')
              .gsub("вЂ™","'")
              .gsub("вЂў", "\n•")
              .gsub("–є", "\n- ")
              .gsub("—Џ", "\n•")
              .gsub(".в", ".")
              .gsub("вЂ_x0098_", "'")
              .gsub("вЂ¦", "...")
              
              speaker.update(bio: rescueStr)
            end
          end
        
      end
    end
    puts "All speakers bio has been updated"
  end
end
