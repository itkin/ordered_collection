ActiveRecord::Schema.define(:version => 0) do

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "number"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.integer  "number"
    t.integer  "user_id"
  end

  create_table "interviews", :force => true do |t|
    t.string   "title"
    t.integer  "number"
    t.integer  "user_id"
  end

end