class AllowNullCommitSubject < ActiveRecord::Migration
  def change
    change_column :commits, :subject, :string, :null => true
  end
end
