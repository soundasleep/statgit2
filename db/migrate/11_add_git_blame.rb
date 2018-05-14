class AddGitBlame < ActiveRecord::Migration[4.2]
  def change
    # A git blame is for a single commit, and records a list of all
    # authors for a given file, and a count of how many lines of that
    # file the author owns.
    create_table :git_blames do |t|
      t.integer  "commit_id",      null: false
      t.integer  "commit_file_id", null: false
      t.integer  "author_id",      null: true     # if the author can't be found
      t.integer  "line_count",     null: false
    end

    add_index "git_blames", ["commit_id"]
    add_index "git_blames", ["commit_file_id"]
    add_index "git_blames", ["author_id"]
  end
end
