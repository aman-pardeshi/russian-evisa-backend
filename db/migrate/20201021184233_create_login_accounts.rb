class CreateLoginAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :login_accounts do |t|
      t.string :type
      t.json :auth_hash
      t.references :user
      t.timestamps
    end
  end
end
