class StoreFilePathsSeparately < ActiveRecord::Migration
  def up
    create_table :file_paths do |t|
      t.string  "path",         null: true
    end

    add_index "file_paths", ["path"]

    # Initially this column is nullable
    add_column :commit_files, :file_path_id, :integer, null: true
    add_index "commit_files", ["file_path_id"]

    sql = "SELECT DISTINCT full_path FROM commit_files"
    distinct_paths = ActiveRecord::Base.connection.exec_query(sql).rows

    i = 0
    distinct_paths.each do |path|
      i += 1
      path = path[0]
      puts "Migrated #{i} of #{distinct_paths.count} distinct paths [#{path}]" if i % 100 == 0

      sql = "INSERT INTO file_paths (path) VALUES (?)"
      sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, path])
      ActiveRecord::Base.connection.exec_query(sql) or raise "Could not SQL #{sql}"

      sql = "UPDATE commit_files SET file_path_id=(SELECT id FROM file_paths WHERE path=?) WHERE full_path=?"
      sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, path, path])
      ActiveRecord::Base.connection.exec_query(sql) or raise "Could not SQL #{sql}"
    end

    # We should now have all valid file_path_ids, so we can set null: false
    change_column :commit_files, :file_path_id, :integer, null: false
    remove_column :commit_files, :full_path
  end

  def down
    # Not strictly irreversible but I don't want to write the code
    raise ActiveRecord::IrreversibleMigration
  end
end
