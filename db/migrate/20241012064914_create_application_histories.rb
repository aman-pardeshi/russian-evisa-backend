class CreateApplicationHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :application_histories do |t|
      t.references :application, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
