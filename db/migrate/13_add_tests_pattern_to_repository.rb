class AddTestsPatternToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :only_paths_matching, :text, null: true
  end
end
