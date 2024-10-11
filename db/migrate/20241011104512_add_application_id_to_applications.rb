class AddApplicationIdToApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :application_id, :string, unique: true
  end
end
