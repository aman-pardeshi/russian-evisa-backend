class CreateApplication < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.uuid :reference_id, unique: true 
      t.string :submission_id, unique: true 
      t.references :user
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :place_of_birth
      t.string :gender
      t.string :country
      t.string :email
      t.string :country_code
      t.string :mobile
      t.string :passport_number
      t.string :passport_place_of_issue
      t.string :passport_date_of_issue
      t.string :passport_expiry_date
      t.string :intented_date_of_entry
      t.boolean :is_other_nationality
      t.string :other_nationality
      t.string :year_of_acquistion
      t.string :photo
      t.string :passport_photo_front
      t.string :passport_photo_back
      t.string :visa_fee
      t.string :service_fee
      t.integer :status, :default => 0
      t.integer :payment_status, :default => 0
      t.string :payment_reference_number
      t.datetime :submitted_on
      t.datetime :visa_applied_at
      t.references :visa_applied_by
      t.datetime :approved_at
      t.references :approved_by
      t.string :approval_document
      t.datetime :rejected_at
      t.references :rejected_by
      t.string :rejection_note

      t.timestamps 
    end
  end
end
