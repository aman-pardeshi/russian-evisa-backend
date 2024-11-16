class AddAdditionalInformation < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :home_address, :string
    add_column :applications, :trip_purpose, :string
    add_column :applications, :return_date, :date
    add_column :applications, :currently_employed_or_studying, :string
    add_column :applications, :employment_or_study_details, :json
    add_column :applications, :type_of_accommodation, :string
    add_column :applications, :locality, :string
    add_column :applications, :accommodation_details, :json
    add_column :applications, :marital_status, :string
    add_column :applications, :partner_details, :json
    add_column :applications, :has_mother, :boolean
    add_column :applications, :mother_details, :json
    add_column :applications, :has_father, :boolean
    add_column :applications, :father_details, :json
    add_column :applications, :visited_countries_recently, :boolean
    add_column :applications, :visited_countries_details, :json
  end
end
