class AllowNullCommitParentHashes < ActiveRecord::Migration[4.2]
  def change
    # For git projects initialised with git-svn it's possible to have
    # a nil parent hash. See e.g. https://github.com/soundasleep/openclerk@69418e9e8c53ebe196ceadf68ff2ff54a0b261d1
    change_column :commits, :parent_hashes, :string, :null => true
  end
end
