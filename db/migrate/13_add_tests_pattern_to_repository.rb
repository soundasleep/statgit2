class AddTestsPatternToRepository < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :only_paths_matching, :text, null: true
  end
end
