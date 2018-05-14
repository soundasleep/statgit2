class AddFileSassStylesheets < ActiveRecord::Migration[4.2]
  def change
    create_table :file_sass_stylesheets do |t|
      t.integer "commit_id",    null: false
      t.integer "commit_file_id", null: false

      t.integer "nodes",        null: false

      t.integer "rules",        null: false
      t.integer "properties",   null: false
      t.integer "variables",    null: false
      t.integer "comments",     null: false

      t.integer "directives",   null: false
      t.integer "imports",      null: false
      t.integer "medias",       null: false

      t.integer "extends",      null: false
      t.integer "mixin_definitions", null: false
      t.integer "mixins",       null: false
    end

    add_index "file_sass_stylesheets", ["commit_id"]
    add_index "file_sass_stylesheets", ["commit_file_id"]
  end
end
