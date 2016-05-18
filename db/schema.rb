ActiveRecord::Schema.define(version: 0) do
  create_table :schema do |t|
  end

  create_table :repositories do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table :commits do |t|
    t.string   "hash"
    t.text     "message"
  end
end
