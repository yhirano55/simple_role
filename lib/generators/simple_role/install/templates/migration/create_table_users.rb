class CreateTableUsers < <%= migration_class_name %>
  def change
    create_table :<%= model_class_name.tableize %> do |t|
      t.integer :role, null: false, limit: 1, default: 0

      t.timestamp null: false
    end
  end
end
