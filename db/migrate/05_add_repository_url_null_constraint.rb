class AddRepositoryUrlNullConstraint < ActiveRecord::Migration
  def change
    change_column :repositories, :url, :string, :null => false
  end
end
