class RemoveUnnecessaryDatetimeColumns < ActiveRecord::Migration
  def change
    remove_column :commit_files, :created_at, :datetime, :null => false
    remove_column :commit_files, :updated_at, :datetime, :null => false
    remove_column :commit_files, :lines_of_code_stats, :datetime, :null => false
    remove_column :commit_files, :lines_of_code_stats, :datetime, :null => false
    remove_column :commit_files, :commit_diffs, :datetime, :null => false
    remove_column :commit_files, :commit_diffs, :datetime, :null => false
    remove_column :commit_files, :file_todos, :datetime, :null => false
    remove_column :commit_files, :file_todos, :datetime, :null => false
  end
end
