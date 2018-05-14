class AddRepositoryUrlNullConstraint < ActiveRecord::Migration[4.2]
  def change
    change_column :repositories, :url, :string, :null => false
  end
end
