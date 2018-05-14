class StoreFilePathsSeparately < ActiveRecord::Migration[4.2]
  def up
    create_table :file_paths do |t|
      t.string  "path",         null: true
      t.integer "repository_id", null: false
    end

    add_index "file_paths", ["path"]
    add_index "file_paths", ["repository_id"]

    # Initially this column is nullable
    add_column :commit_files, :file_path_id, :integer, null: true
    add_index "commit_files", ["file_path_id"]

    sql = "SELECT id FROM repositories"
    repository_ids = ActiveRecord::Base.connection.exec_query(sql).rows

    repository_ids.each do |repository|
      repository = repository[0]
      LOG.info "Migrating repository #{repository}..."

      sql = "SELECT DISTINCT full_path FROM commit_files WHERE commit_id IN (SELECT id FROM commits WHERE repository_id=?)"
      sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, repository])
      distinct_paths = ActiveRecord::Base.connection.exec_query(sql).rows

      i = 0
      distinct_paths.each do |path|
        i += 1
        path = path[0]
        LOG.info "Migrated #{i} of #{distinct_paths.count} distinct paths [#{path}]" if i % 100 == 0

        sql = "INSERT INTO file_paths (path, repository_id) VALUES (?, ?)"
        sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, path, repository])
        ActiveRecord::Base.connection.exec_query(sql) or raise "Could not SQL #{sql}"

        sql = "UPDATE commit_files SET file_path_id=(SELECT id FROM file_paths WHERE path=?) WHERE full_path=? AND commit_id IN (SELECT id FROM commits WHERE repository_id=?)"
        sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, path, path, repository])
        ActiveRecord::Base.connection.exec_query(sql) or raise "Could not SQL #{sql}"
      end
    end

    # We should now have all valid file_path_ids, so we can set null: false
    change_column :commit_files, :file_path_id, :integer, null: false
    remove_column :commit_files, :full_path
  end

  def down
    # Not strictly irreversible but I don't want to write the code right now
    raise ActiveRecord::IrreversibleMigration
  end
end
