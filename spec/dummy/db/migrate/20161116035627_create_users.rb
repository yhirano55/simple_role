class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.integer :role, null: false, limit: 1, default: 0

      t.timestamps null: false
    end
  end
end
