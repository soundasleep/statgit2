class AddCommitBlames < ActiveRecord::Migration
  def change
    create_table :commit_blames do |t|
      # blame as of this commit
      t.integer "commit_id",      null: false
      t.integer "commit_file_id", null: false

      t.integer "line_number_in_original_file", null: false
      t.integer "line_number_in_final_file", null: false
      t.integer "lines_in_group", null: true

      # if we can identify the author
      t.integer "author_id",      null: true

      # and if we can identify the referenced commit
      t.integer "referenced_commit_id", null: true
    end

    add_index "commit_blames", ["commit_id"]
    add_index "commit_blames", ["commit_file_id"]
    add_index "commit_blames", ["author_id"]
    add_index "commit_blames", ["referenced_commit_id"]
  end
end
