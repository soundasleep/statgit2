class ReremoveUnnecessaryDatetimeColumns < ActiveRecord::Migration[4.2]
  def change
    remove_column :lines_of_code_stats, :created_at, :datetime, :null => false
    remove_column :lines_of_code_stats, :updated_at, :datetime, :null => false
    remove_column :commit_diffs, :created_at, :datetime, :null => false
    remove_column :commit_diffs, :updated_at, :datetime, :null => false
    remove_column :file_todos, :created_at, :datetime, :null => false
    remove_column :file_todos, :updated_at, :datetime, :null => false

    # Reset the associated schema caches
    LinesOfCodeStat.reset_column_information
    CommitDiff.reset_column_information
    FileTodo.reset_column_information
  end
end
