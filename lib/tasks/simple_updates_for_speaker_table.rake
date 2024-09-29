namespace "simple_updates_for_speaker_table" do
    
    desc "Update the column values in speaker table"

    task speaker_table_update_task: :environment do 
        Speaker.select(Arel.star).where(company_name: nil).update(company_name: "-")

        Speaker.select(Arel.star).where(designation: nil).update(designation: "-")

        # Speaker.where.not(id: Speaker.group(:linkedin_url).select("min(id)"))
        
    end
end
  