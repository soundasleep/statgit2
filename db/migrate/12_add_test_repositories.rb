class AddTestRepositories < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :parent_repository_id, :integer, null: true
    add_index  :repositories, ["parent_repository_id"]

    add_column :repositories, :is_tests_only, :boolean, null: false, default: false
    add_index  :repositories, ["is_tests_only"]
  end
end
