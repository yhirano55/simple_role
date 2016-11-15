class CreateTableManagedResources < ActiveRecord::Migration[5.0]
  def change
    create_table :managed_resources do |t|
      t.string :class_name, null: false
      t.string :action,     null: false
      t.string :name

      t.timestamp null: false
    end

    add_index :managed_resources, [:class_name, :action, :name], unique: true
  end
end
