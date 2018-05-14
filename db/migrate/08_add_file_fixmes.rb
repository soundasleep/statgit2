class AddFileFixmes < ActiveRecord::Migration[4.2]
  def change
    create_table :file_fixmes do |t|
      t.integer  "commit_id",      null: false
      t.integer  "commit_file_id", null: false
      t.integer  "fixme_count",    null: false
    end

    # We don't want these tables to have created_at, updated_at
    # because that is a *lot* of additional information that is unnecessary.
    # (We can always just delete the rows and run the analysis again.)
    remove_column :file_fixmes, :created_at, :datetime, :null => false
    remove_column :file_fixmes, :updated_at, :datetime, :null => false

    add_index "file_fixmes", ["commit_id"]
    add_index "file_fixmes", ["commit_file_id"]
  end
end
