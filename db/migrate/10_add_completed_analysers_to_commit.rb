class AddCompletedAnalysersToCommit < ActiveRecord::Migration[4.2]
  def change
    create_table :completed_analysers do |t|
      t.integer  "commit_id",      null: false
      t.string   "class_name",     null: false
    end

    add_index :completed_analysers, ["commit_id", "class_name"]
  end
end
