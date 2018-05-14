class AllowNullCommitSubject < ActiveRecord::Migration[4.2]
  def change
    change_column :commits, :subject, :string, :null => true
  end
end
