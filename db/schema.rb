ActiveRecord::Schema.define(version: 0) do
  create_table :schema do |t|
  end

  create_table :repositories do |t|
    t.string   "url"

    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table :commits do |t|
    t.integer  "repository_id", null: false
    t.string   "commit_hash",   null: false
    t.string   "short_hash",    null: false
    t.string   "tree_hash",     null: false
    t.string   "parent_hashes", null: false
    t.string   "author_name",   null: false
    t.string   "author_email",  null: false
    t.datetime "author_date",   null: false
    t.string   "committer_name",   null: false
    t.string   "committer_email",  null: false
    t.datetime "committer_date",   null: false
    t.string   "subject",       null: false
    t.string   "body"
    t.string   "commit_notes"

    t.integer  "author_id"

    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "commits", ["repository_id"]
  add_index "commits", ["commit_hash"]
  add_index "commits", ["author_id"]

  create_table :authors do |t|
    t.integer  "repository_id", null: false
    t.string   "email"
    t.string   "name",          null: false

    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "authors", ["repository_id"]
  add_index "authors", ["email"]

  create_table :commit_files do |t|
    t.integer  "commit_id",     null: false
    t.string   "full_path",     null: false
    t.integer  "size",          null: false

    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "commit_files", ["commit_id"]
  add_index "commit_files", ["full_path"]

  create_table :lines_of_code_stats do |t|
    t.integer  "commit_id",     null: false
    t.string   "language",      null: false
    t.integer  "files",         null: false
    t.integer  "blank",         null: false
    t.integer  "comment",       null: false
    t.integer  "code",          null: false

    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "lines_of_code_stats", ["commit_id"]
  add_index "lines_of_code_stats", ["language"]
end
