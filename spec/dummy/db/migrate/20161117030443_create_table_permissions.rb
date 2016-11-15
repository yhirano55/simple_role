class CreateTablePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.integer :managed_resource_id, null: false
      t.integer :role,                null: false, limit: 1, default: 0
      t.integer :state,               null: false, limit: 1, default: 0

      t.timestamp null: false
    end

    add_index :permissions, [:managed_resource_id, :role], unique: true
  end
end
