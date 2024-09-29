class InstallAudited < ActiveRecord::Migration[6.0]
  def self.up
    Audited::Audit.connection.create_table :audits, :force => true do |t|
      t.column :auditable_id, :integer
      t.column :auditable_type, :string
      t.column :associated_id, :integer
      t.column :associated_type, :string
      t.column :user_id, :integer
      t.column :user_type, :string
      t.column :username, :string
      t.column :action, :string
      t.column :audited_changes, :text
      t.column :version, :integer, :default => 0
      t.column :comment, :string
      t.column :remote_address, :string
      t.column :request_uuid, :string
      t.column :created_at, :datetime
    end

    Audited::Audit.connection.add_index :audits, [:auditable_type, :auditable_id, :version], :name => 'auditable_index'
    Audited::Audit.connection.add_index :audits, [:associated_type, :associated_id], :name => 'associated_index'
    Audited::Audit.connection.add_index :audits, [:user_id, :user_type], :name => 'user_index'
    Audited::Audit.connection.add_index :audits, :request_uuid
    Audited::Audit.connection.add_index :audits, :created_at
  end

  def self.down
    Audited::Audit.connection.drop_table :audits
  end
end
